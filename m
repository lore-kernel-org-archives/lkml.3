Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaIDQUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:20:05 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53089 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbaIDQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <1409761696-15435-5-git-send-email-gdjakov@mm-sol.com>
References: <1409761696-15435-1-git-send-email-gdjakov@mm-sol.com>
	<1409761696-15435-5-git-send-email-gdjakov@mm-sol.com>
Date: Thu, 4 Sep 2014 18:20:01 +0200
Message-ID: <CACRpkdZQouNk0z1AQHbjULJXdRK07-kZDXLcnx0Xayew0fnocA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] pinctrl: qcom: Make the target processor value configurable
From: Linus Walleij <linus.walleij@linaro.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: Kumar Gala <galak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 6:28 PM, Georgi Djakov <gdjakov@mm-sol.com> wrote:

> Currently the value used to specify that interrupts from the gpio should
> be routed to the application processor is hardcoded for all Qualcomm SoCs.
> But the new APQ8084 SoC uses a different value. To resolve this, we make
> this value configurable for each SoC. For all existing SoCs we continue
> to use the current value, and only for APQ8084 we use the new value.
>
> Suggested-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>

Patch applied.

Yours,
Linus Walleij
