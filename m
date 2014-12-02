Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaLBPBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:01:40 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41694 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923AbaLBPBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:01:37 -0500
Date: Tue, 2 Dec 2014 15:01:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thor Thayer <tthayer@opensource.altera.com>
Cc: "bp@alien8.de" <bp@alien8.de>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tthayer.linux@gmail.com" <tthayer.linux@gmail.com>
Subject: Re: [RESEND PATCHv5 5/5] arm: dts: Add Altera L2 Cache and OCRAM EDAC
Message-ID: <20141202150118.GM23671@leverpostej>
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com>
 <1415751263-1830-6-git-send-email-tthayer@opensource.altera.com>
 <546BB27A.20405@opensource.altera.com>
 <547CD3ED.1080804@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547CD3ED.1080804@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thor,

On Mon, Dec 01, 2014 at 08:47:41PM +0000, Thor Thayer wrote:
> Hi Boris,
> 
> On 11/18/2014 02:56 PM, Thor Thayer wrote:
> > Hi all,
> >
> > On 11/11/2014 06:14 PM, tthayer@opensource.altera.com wrote:
> >> From: Thor Thayer<tthayer@opensource.altera.com>
> >>
> >> Adding the device tree entries and bindings needed to support
> >> the Altera L2 cache and On-Chip RAM EDAC. This patch relies upon
> >> an earlier patch to declare and setup On-chip RAM properly.
> >> http://www.spinics.net/lists/devicetree/msg51117.html
> >
> > Any comments on these devicetree additions?
> >
> > Thanks,
> > Thor
> >> Signed-off-by: Thor Thayer<tthayer@opensource.altera.com>
> >> ---
> >> v2: Remove OCRAM declaration and reference prior patch.
> >>
> >> v3-5: No Change
> >> ---
> 
> I originally submitted this series on November 11, 2014.
> 
> I haven't received any comments or ACKs on the device tree patch portion 
> (patch 5 of 5). According to 
> Documentation/devicetree/bindings/submitting-patches.txt, if the patch 
> hasn't been Acked after a couple of weeks, the maintainer can pull the 
> changes if they are comfortable with those changes.

Apologies it has taken so long for this to be looked at. Unfortunately
my inbox is overflowing (as are all of ours) and things fall by the
wayside. I am sorry that this has lead to such a delayed response,
especially given that it was negative.

I'll try to keep up with this a bit more actively.

Thanks,
Mark.
