Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaHTPmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:42:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53400 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaHTPmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:42:03 -0400
Date: Wed, 20 Aug 2014 10:42:00 -0500
From: Andy Gross <agross@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Georgi Djakov <gdjakov@mm-sol.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "iivanov@mm-sol.com" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] pinctrl: qcom: Add APQ8084 pinctrl support
Message-ID: <20140820154200.GA14731@qualcomm.com>
References: <1408468936-12252-1-git-send-email-gdjakov@mm-sol.com>
 <1408468936-12252-2-git-send-email-gdjakov@mm-sol.com>
 <20140820043929.GH7070@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820043929.GH7070@sonymobile.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 09:39:30PM -0700, Bjorn Andersson wrote:
> On Tue 19 Aug 10:22 PDT 2014, Georgi Djakov wrote:
> 
> > This patch adds support for the TLMM (Top-Level Mode Mux) block found
> > in the APQ8084 platform.
> > 
> [...]
> > +
> > +#define NUM_GPIO_PINGROUPS 143
> > +
> 
> I think this looks good overall, but in my APQ8084 documentation
> (80-NG550-2X Rev. B) there are 147 (0..146) gpio pins in the TLMM block.
> 
> Any suggestion to why there's a discrepancy?
> 

We have some discrepancies internally on the documentation.  However, in this
case I'd expect the OEM documentation to be correct.  So this needs to change to
bjorn's version, as it appears to be the correct version.

I have no idea why some pins are missing.


-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
