Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161042AbaEMWOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:14:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58752 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbaEMWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:13:15 -0400
Date: Tue, 13 May 2014 15:13:13 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v1 01/11] ARM: amba: Add Qualcomm vendor ID.
Message-ID: <20140513221313.GI20486@codeaurora.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1398759542-13017-1-git-send-email-srinivas.kandagatla@linaro.org>
 <CACRpkdZyEAkJUGC5x6CY65-g97jfyg-TMDoe8JxDMexVx5usSA@mail.gmail.com>
 <5371E8B7.8000103@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5371E8B7.8000103@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Srinivas Kandagatla wrote:
> Thanks Linus W,
> 
> On 13/05/14 08:16, Linus Walleij wrote:
> >On Tue, Apr 29, 2014 at 10:19 AM,  <srinivas.kandagatla@linaro.org> wrote:
> >
> >>From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> >>
> >>This patch adds Qualcomm amba vendor Id to the list. This ID is used in mmci
> >>driver.
> >>
> >>Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> >(...)
> >>+       AMBA_VENDOR_QCOM = 0x51,
> >
> >Yeah it's a "Q", like 0x41 is "A" for ARM. You could as well mention
> >this in the commit message.
> >
> Sounds good, I will fix it in next version and send it to Russell's
> patch tracker.
> 

Please add a note that this id is fake in the commit text or in
the code as well.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
