Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3HFX60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:58:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589Ab3HFX6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:58:25 -0400
Date: Wed, 7 Aug 2013 01:58:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] pktcdvd: Fix defective misuses of pkt_<level>
In-Reply-To: <20130806132126.5c25f89bcd3311e636937712@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1308070154230.10817@pobox.suse.cz>
References: <20130801154452.GB5198@elgon.mountain> <1375474254.2034.134.camel@joe-AO722> <20130806132126.5c25f89bcd3311e636937712@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Aug 2013, Andrew Morton wrote:

> > Andrew, I believe Jiri picked up this series and
> > you can drop them from mm.  Thanks.
> 
> Shall do if/when they turn up in linux-next.

Pull request to Jens is there [1], but his branch has been silent for two 
weeks ...

[1] https://lkml.org/lkml/2013/7/30/277

-- 
Jiri Kosina
SUSE Labs
