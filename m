Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab3J2PNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:13:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35272 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3J2PNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:13:53 -0400
Date: Tue, 29 Oct 2013 10:12:38 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Gilad Avidov <gavidov@codeaurora.org>,
        linux-kernel@vger.kernel.org, Michael Bohan <mbohan@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 06/10] spmi: document the PMIC arbiter SPMI bindings
Message-ID: <20131029151238.GF20207@joshc.qualcomm.com>
References: <cover.1382985169.git.joshc@codeaurora.org>
 <043d714725f8b6df1873047164d2d0e78778138b.1382985169.git.joshc@codeaurora.org>
 <1383055709.2837.17.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383055709.2837.17.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 04:08:29PM +0200, Ivan T. Ivanov wrote:
> On Mon, 2013-10-28 at 13:12 -0500, Josh Cartwright wrote: 
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > ---
> >  .../bindings/spmi/qcom,spmi-pmic-arb.txt           | 42 ++++++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> > new file mode 100644
> > index 0000000..68949aa
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> > @@ -0,0 +1,42 @@
> > +Qualcomm SPMI Controller (PMIC Arbiter)
> > +
> > +The SPMI PMIC Arbiter is found on the Snapdragon 800 Series.  It is an SPMI
> > +controller with wrapping arbitration logic to allow for multiple on-chip
> > +devices to control a single SPMI master.
> > +
> > +The PMIC Arbiter can also act as an interrupt controller, providing interrupts
> > +to slave devices.
> > +
> > +See spmi.txt for the generic SPMI controller binding requirements for child
> > +nodes.
> > +
> > +Required properties:
> > +- compatible : should be "qcom,spmi-pmic-arb".
> > +- reg-names  : should be "core", "intr", "cnfg"
> > +- reg : offset and length of the PMIC Arbiter Core register map.
> > +- reg : offset and length of the PMIC Arbiter Interrupt controller register map.
> > +- reg : offset and length of the PMIC Arbiter Configuration register map.
> > +- #address-cells : must be set to 1
> 
> This doesn't seem to follow generic set of bindings for the SPMI
> controllers. #address-cells : must be set to 2.

Indeed, good catch.  I'll fix it up.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
