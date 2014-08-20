Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaHTEji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:39:38 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6599 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbaHTEjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:39:37 -0400
Date: Tue, 19 Aug 2014 21:39:30 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "agross@codeaurora.org" <agross@codeaurora.org>,
        "iivanov@mm-sol.com" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] pinctrl: qcom: Add APQ8084 pinctrl support
Message-ID: <20140820043929.GH7070@sonymobile.com>
References: <1408468936-12252-1-git-send-email-gdjakov@mm-sol.com>
 <1408468936-12252-2-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1408468936-12252-2-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19 Aug 10:22 PDT 2014, Georgi Djakov wrote:

> This patch adds support for the TLMM (Top-Level Mode Mux) block found
> in the APQ8084 platform.
> 
[...]
> +
> +#define NUM_GPIO_PINGROUPS 143
> +

I think this looks good overall, but in my APQ8084 documentation
(80-NG550-2X Rev. B) there are 147 (0..146) gpio pins in the TLMM block.

Any suggestion to why there's a discrepancy?

Regards,
Bjorn
