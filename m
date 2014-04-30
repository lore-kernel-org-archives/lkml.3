Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbaD3VQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:16:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32853 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964937AbaD3VQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:16:37 -0400
Date: Wed, 30 Apr 2014 14:16:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/4] devicetree: bindings: qcom,mmcc: Document GDSC
 binding
Message-ID: <20140430211635.GF20486@codeaurora.org>
References: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
 <1396637136-29974-5-git-send-email-sboyd@codeaurora.org>
 <20140429070737.7224.72350@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429070737.7224.72350@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Mike Turquette wrote:
> Quoting Stephen Boyd (2014-04-04 11:45:36)
> > +Example:
> > +       clock-controller@4000000 {
> > +               compatible = "qcom,mmcc-msm8974";
> > +               reg = <0x4000000 0x1000>;
> > +               #clock-cells = <1>;
> > +               #reset-cells = <1>;
> > +
> > +               regulators {
> > +                       gdsc_oxili_gx: gdsc_oxili_gx {
> > +                               regulator-name = "gdsc_oxili_gx";
> 
> Hi Stephen,
> 
> It makes sense to model the gdsc's as regulators. It also makes sense to
> nest them within the clock-controller node, assuming that matches the
> register manual for your part.
> 
> However, does it make sense to put this new code under drivers/clk/qcom?
> I don't see a compelling reason. How about breaking the registers out
> into a header for easier reuse?

What registers are we talking about? I put this under
drivers/clk/qcom because it's one device that happens to have all
these different driver subsystems in it (clocks, reset, gdsc).

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
