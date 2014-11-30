Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaK3XJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 18:09:21 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18950 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032AbaK3XJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 18:09:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEdAM+ie1R5LLkm/2dsb2JhbABbgwaBKbNMAQEBAgEGlE+FIgICAQECgQkXAQEBAQF9hAIBAQEEOhwjEAgDFAEDCSUPBSUDIROIP9FzAQEBAQEFAQEBAR4Yhh+JYGQHgymBHwWOfY1JlUSEDyswgQSBQwEBAQ
Date: Mon, 1 Dec 2014 10:09:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] XFS: Deletion of unnecessary checks before two
 function calls
Message-ID: <20141130230904.GF16151@dastard>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <5479F823.60900@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5479F823.60900@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 05:45:23PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 29 Nov 2014 17:40:22 +0100
> 
> The functions xfs_blkdev_put() and xfs_qm_dqrele() test whether their argument
> is NULL and then return immediately.
> Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com
