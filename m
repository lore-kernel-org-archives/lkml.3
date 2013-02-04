Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3BDSfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:35:16 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:54882 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab3BDSfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:35:14 -0500
Date: Mon, 4 Feb 2013 10:35:08 -0800
From: Tejun Heo <tj@kernel.org>
To: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 02/14] atm/nicstar: don't use idr_remove_all()
Message-ID: <20130204183508.GU27963@mtj.dyndns.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-3-git-send-email-tj@kernel.org>
 <20130204175210.GQ27963@mtj.dyndns.org>
 <20130204131034.5bea17c4@thirdoffive.cmf.nrl.navy.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204131034.5bea17c4@thirdoffive.cmf.nrl.navy.mil>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Feb 04, 2013 at 01:10:34PM -0500, chas williams - CONTRACTOR wrote:
> you assign id1 to 0, so this never happens i think.  i don't think the
> reason to preassign id1/id2 exists anymore once the do loop is removed.
> 
> > +			id1 = idr_alloc(&card->idr, handle1, 0, 0, GFP_ATOMIC);
> > +			if (id1 < 0) {
> > +				err = id1;
> 
> you dont need to assign err since it isn't returned.

Heh, I put v2 under the wrong thread.  I'll do v3 and post it under
v1.

Thanks.

-- 
tejun
