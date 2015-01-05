Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbbAEI6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:58:05 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:39527 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbAEI6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:58:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org, sboyd@codeaurora.org,
        linux-sh@vger.kernel.org, vksavl@gmail.com, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2] clk-rcar-gen2: RCAN clock support
Date: Mon, 05 Jan 2015 10:58:12 +0200
Message-ID: <2588771.7HSTAuAcWR@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1550804.XpyQtHjy2T@avalon>
References: <3007073.i0ghnTEhxV@wasted.cogentembedded.com> <1550804.XpyQtHjy2T@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Monday 05 January 2015 10:53:02 Laurent Pinchart wrote:
> On Thursday 25 December 2014 01:17:29 Sergei Shtylyov wrote:
> > Add the RCAN clock support to the R-Car generation 2 CPG driver.  This
> > clock gets derived from  the USB_EXTAL clock, dividing  it by 6.  The
> > layout of the RCANCKCR register is similar to those of the clocks
> > supported by the 'clk-div6' driver but has no divider field, and so can't
> > be supported by that driver...
> > 
> > Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > 
> > ---
> > The patch is against the 'clk-next' branch of Mike Turquette's 'linux.git'
> > repo.
> > 
> > Changes in version 2:
> > - switched to using the composite clock driver with the fixed factor and
> > gated clock component drivers;
> > - removed *static* from 'parent_name' definition, switching from
> > assignment to initializer;
> > - modified the binding document;
> > - modified the changelog.
> > 
> >  Documentation/devicetree/bindings/clock/renesas,rcar-gen2-cpg-clocks.txt
> >  | 5 -
> >  drivers/clk/shmobile/clk-rcar-gen2.c                    |   40 ++++++++++
> 
> Could you please also add a #define for the RCAN clock in include/dt-
> bindings/clock/r8a779*-clock.h ? Same comment for the ADSP clock in "[PATCH]
> clk-rcar-gen2: ADSP clock support".

Scratch that, I see you add the #define's in the patches that add the 
corresponding MSTP clocks.

-- 
Regards,

Laurent Pinchart

