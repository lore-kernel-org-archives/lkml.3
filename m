Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab3HFUV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:21:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab3HFUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:21:27 -0400
Date: Tue, 6 Aug 2013 13:21:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, kernel-janitors@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pktcdvd: Fix defective misuses of pkt_<level>
Message-Id: <20130806132126.5c25f89bcd3311e636937712@linux-foundation.org>
In-Reply-To: <1375474254.2034.134.camel@joe-AO722>
References: <20130801154452.GB5198@elgon.mountain>
	<1375474254.2034.134.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug 2013 13:10:54 -0700 Joe Perches <joe@perches.com> wrote:

> Andrew, I believe Jiri picked up this series and
> you can drop them from mm.  Thanks.

Shall do if/when they turn up in linux-next.
