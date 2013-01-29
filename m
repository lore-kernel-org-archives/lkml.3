Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab3A2Jwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:52:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab3A2Jwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:52:47 -0500
Date: Tue, 29 Jan 2013 10:52:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Steve Wise <swise@opengridcomputing.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Hal Rosenstock <hal.rosenstock@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>, Roland Dreier <roland@kernel.org>,
        Steve Wise <swise@chelsio.com>
Subject: Re: [PATCH] IB: cxgb3: delay freeing mem untill entirely done with
 it
In-Reply-To: <50F47BE8.5000002@opengridcomputing.com>
Message-ID: <alpine.LNX.2.00.1301291052240.23853@pobox.suse.cz>
References: <alpine.LNX.2.00.1301142031050.31033@swampdragon.chaosbits.net> <50F47BE8.5000002@opengridcomputing.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013, Steve Wise wrote:

> Reviewed-by: Steve Wise <swise@opengridcomputing.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
