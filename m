Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaAFSaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:30:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34921 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755780AbaAFSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:30:12 -0500
Date: Mon, 6 Jan 2014 18:30:00 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, devicetree <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/2] of: add vendor prefix for Mentor Graphics
Message-ID: <20140106183000.GL24664@e106331-lin.cambridge.arm.com>
References: <1387470351-4696-1-git-send-email-bigeasy@linutronix.de>
 <D53158FF-7BCF-4BA8-A589-B6365B4DA058@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D53158FF-7BCF-4BA8-A589-B6365B4DA058@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 05:26:02PM +0000, Kumar Gala wrote:
> 
> On Dec 19, 2013, at 10:25 AM, Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> 
> > This prefix is currently used for the musb driver.
> > 
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> > Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
> > 1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> > index 8c75d85..cb5c438 100644
> > --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> > +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> > @@ -43,6 +43,7 @@ linux	Linux-specific binding
> > lsi	LSI Corp. (LSI Logic)
> > marvell	Marvell Technology Group Ltd.
> > maxim	Maxim Integrated Products
> > +mentor	Mentor Graphics
> 
> file like we should use ‘ment’, but not sure if we are going away from ticker symbols or not.

In general we've been heading towards full names rather than stock
ticker symbols. It's far easier for a human to make an educated guess
without searching.

I'm certainly happy with mentor as a vendor prefix.

Mark.

> 
> > microchip	Microchip Technology Inc.
> > mosaixtech	Mosaix Technologies, Inc.
> > national	National Semiconductor
> > -- 
> > 1.8.5.1
> > 
> 
> - k
> 
> -- 
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
> 
> 
