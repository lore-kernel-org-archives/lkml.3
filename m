Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3HPWaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:30:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54103 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3HPWaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:30:02 -0400
Date: Fri, 16 Aug 2013 14:25:49 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] spmi: document the PMIC arbiter SPMI bindings
Message-ID: <20130816192549.GG4035@joshc.qualcomm.com>
References: <cover.1376596224.git.joshc@codeaurora.org>
 <b639088d50df93caaef8fe7e09c12953b1153ce8.1376596224.git.joshc@codeaurora.org>
 <D1534646-7CB5-4EE7-8C1E-1C607BE22396@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D1534646-7CB5-4EE7-8C1E-1C607BE22396@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Kumar-

Thanks for the review.

On Fri, Aug 16, 2013 at 01:53:27PM -0500, Kumar Gala wrote:
> On Aug 9, 2013, at 3:37 PM, Josh Cartwright wrote:
> 
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > ---
> > .../devicetree/bindings/spmi/spmi-pmic-arb.txt     | 26 ++++++++++++++++++++++
> > 1 file changed, 26 insertions(+)
> > create mode 100644 Documentation/devicetree/bindings/spmi/spmi-pmic-arb.txt
> 
> As this is a qcom specific binding, I think the file name should be msm-spmi-pmic-arb.txt or something like that.

Agreed.  It might be nice to use a vendor prefix in the name too.  How's qcom,msm-pmic-arb.txt sound?

> > diff --git a/Documentation/devicetree/bindings/spmi/spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/spmi-pmic-arb.txt
> > new file mode 100644
> > index 0000000..1c14bf4
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/spmi/spmi-pmic-arb.txt
> > @@ -0,0 +1,26 @@
> > +Qualcomm SPMI Controller (PMIC Arbiter)
> 
> We should get in the habit of trying to have at least one sentence about what the device is or does.

Certainly.

> > +
> > +Required properties:
> > +- compatible : should be "qcom,spmi-pmic-arb".
> > +- reg-names  : should be "core", "intr", "cnfg"
> > +- reg : offset and length of the PMIC Arbiter Core register map.
> > +- reg : offset and length of the PMIC Arbiter Interrupt controller register map.
> > +- reg : offset and length of the PMIC Arbiter Configuration register map.
> > +- #address-cells : must be set to 1
> > +- #size-cells : must be set to 0
> 
> Hmm, you aren't describe anything about child nodes.

Indeed.  I'll put together a generic SPMI binding document as you had
suggested before and reference it in this binding.

  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
