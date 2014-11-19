Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaKSBR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:17:57 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58399 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaKSBR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:17:56 -0500
Date: Wed, 19 Nov 2014 09:17:31 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: Stefan Agner <stefan@agner.ch>, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk, kernel@pengutronix.de, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [[PATCHv2] 3/3] drivers/rtc/rtc-snvs: Add clock support
Message-ID: <20141119011721.GA24042@dragon>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
 <30e496ce2d6521e608df3b68b73b3e05caa1daef.1415364391.git.maitysanchayan@gmail.com>
 <7807253ec0fd349b5bb1489e0d3b1347@agner.ch>
 <546320D3.2030501@gmail.com>
 <20141112104735.GK2704@dragon>
 <54644295.2050003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54644295.2050003@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 11:03:09AM +0530, Sanchayan Maity wrote:
> On Wednesday 12 November 2014 04:17 PM, Shawn Guo wrote:
> > On Wed, Nov 12, 2014 at 02:26:51PM +0530, Sanchayan Maity wrote:
> >> On Wednesday 12 November 2014 02:57 AM, Stefan Agner wrote:
> >>> On 2014-11-07 14:04, Sanchayan Maity wrote:
> >>>> This patch adds clock enable and disable support for
> >>>> the SNVS peripheral, which is required for using the
> >>>> RTC within the SNVS block.
> >>>
> >>> What happens if the device tree node is there while this patch is not
> >>> applied? I guess the driver would load, but since the clocks of the
> >>> peripheral are not enabled the first register access would lead to bus
> >>> error or similar. If this is the case, this would break bisectability.
> >>> You should move the device tree patch to the end.
> >>>
> >>
> >> If the DT node was present with this patch not applied, the driver would 
> >> still crash with a bus error, since the clocks for SNVS are not explicitly 
> >> enabled anywhere else. I had not thought about any problems which might 
> >> occur later with git bisect. Will move this to the end with v3.
> > 
> > Since changes on rtc-snvs.c will need to go through RTC subsystem tree,
> > that means I cannot apply DTS changes until the driver patch gets
> > mainlined and appears on my tree.
> > 
> > Shawn
> 
> Shawn
> 
> So the approach in this patch is OK and acceptable? 

Yes, I'm fine with it.

Shawn

> 
> Since the DT changes cannot be applied by you, till this goes through the 
> RTC subsystem tree, gets mainlined and appears on your tree, I will send out 
> this patch by itself then and send the DT changes later once this gets
> mainlined?
> 
> I did not CC Alessandro Zummo, the maintainer of RTC subsystem by mistake.
> Once you ACK/OK this i will send out this patch in isolation then or just 
> CC Alessandro Zummo.
