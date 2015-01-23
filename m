Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbbAWRKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:10:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30339 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbbAWRKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:10:04 -0500
Date: Fri, 23 Jan 2015 12:09:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Roger Pau Monne <roger.pau@citrix.com>, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen-blk: add myself as maintainer of xen-blk{back/front}
Message-ID: <20150123170955.GA4856@l.oracle.com>
References: <1422029669-24845-1-git-send-email-roger.pau@citrix.com>
 <54C27E10.2010802@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C27E10.2010802@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:00:00PM +0000, David Vrabel wrote:
> On 23/01/15 16:14, Roger Pau Monne wrote:
> > I've done quite a lot of work in blkfront/blkback, and I usually end up
> > looking at the patches, so add myself as maintainer together with Konrad.
> 
> Thanks, Roger.
> 
> I can take care of shovelling the patches onto the xen/tip.git if you
> don't have a kernel.org account.

Please keep in mind that these patches need to go through Jens Axboe as
he is the block maintainer.

So the flow would have to be Roger -> David -> Roger posting GIT PULL To Jens -> Jens -> Linus.
> 
> David
> 
