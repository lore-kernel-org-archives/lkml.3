Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3EYFcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 01:32:50 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51919 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3EYFct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 01:32:49 -0400
Date: Sat, 25 May 2013 14:33:27 +0900
From: Simon Horman <horms@verge.net.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Axel Lin <axel.lin@ingics.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] pwm: renesas-tpu: Add missing pwmchip_remove() call
 in tpu_remove()
Message-ID: <20130525053327.GB9293@verge.net.au>
References: <1369057541.11578.1.camel@phoenix>
 <1454213.B1kNpQ6JtX@avalon>
 <20130523013933.GI22608@verge.net.au>
 <20130523191217.GB17462@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523191217.GB17462@avionic-0098.adnet.avionic-design.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 09:12:17PM +0200, Thierry Reding wrote:
> On Thu, May 23, 2013 at 10:39:34AM +0900, Simon Horman wrote:
> > On Mon, May 20, 2013 at 03:46:59PM +0200, Laurent Pinchart wrote:
> > > Hi Axel,
> > > 
> > > Thank you for the patch.
> > > 
> > > On Monday 20 May 2013 21:45:41 Axel Lin wrote:
> > > > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > > 
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Thanks. I have queued this up for v3.11 in the pinmux branch
> > of my renesas tree on kernel.org.
> 
> I'd rather take this through the PWM tree along with the original driver
> patch.

Sure that is fine.

I had them queued up in my tree but I have dropped them now.
That should propogate to linux-next in the not too distant future.

I have also dropped the following changes from my tree
as they appear to ether depend on the TPU PWD driver or one
of the other patches in the list below.

Laurent, I think it would be best if you resubmitted these patches
once there is a stable branch available with the TPU PWD driver merged
which I can use as a base.

ARM: mach-shmobile: armadillo800eva: Add backlight support
ARM: mach-shmobile: kota2: Use leds-pwm + pwm-rmob
leds: Remove leds-renesas-tpu driver
sh-pfc: sh73a0: Remove function GPIOs

