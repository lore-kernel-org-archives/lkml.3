Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655Ab3D3VLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:11:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306Ab3D3VLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:11:16 -0400
Date: Tue, 30 Apr 2013 23:11:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH 08/26] m32r: Convert print_symbol to %pSR
In-Reply-To: <1367326618.2587.10.camel@joe-AO722>
Message-ID: <alpine.LNX.2.00.1304302308470.20139@pobox.suse.cz>
References: <cover.1355335227.git.joe@perches.com>  <df548c6911e1b46a73b9a417efb800d08e0ecf8f.1355335228.git.joe@perches.com>  <swfr4mu3b2o.wl%hirokazu.takata.wj@renesas.com>  <alpine.LNX.2.00.1304291521070.11889@pobox.suse.cz>
 <1367326618.2587.10.camel@joe-AO722>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Joe Perches wrote:

> > On Thu, 13 Dec 2012, Hirokazu Takata wrote:
> > > Acked-by: Hirokazu Takata <takata@linux-m32r.org>
> 
> Hi Jiri.
> 
> It's really not useful to cherry-pick a few patches
> from this series.
> 
> You must first apply patch 1 of 26 before applying any
> of the others as a new vsprintf pointer extension %pSR
> is added by that patch.

Omitting the actual addition of %pSR is of course completely my fault, 
caused by my incorrect merge into for-linus branch, thanks for noticing 
that. It's now fixed in Linus' tree.

OTOH, cherry-picking the patches that have been Acked by maintainers is 
what I usually do in the first round. For 3.11, I'd like to ask you to 
send me a remaining conversions as one condensed patch, and I'll decide 
whether I'll be taking those or not despite the missing Ack from 
maintainers.

Thanks,

-- 
Jiri Kosina
SUSE Labs
