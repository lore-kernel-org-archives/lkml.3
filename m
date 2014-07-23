Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbaGWVqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:46:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59753 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933568AbaGWVqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:46:49 -0400
Message-ID: <53D02D45.50000@codeaurora.org>
Date: Wed, 23 Jul 2014 14:46:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH RESEND v2 1/4] pinctrl: Update Qualcomm pm8xxx GPIO parameters
 definitions
References: <1405610748-7583-5-git-send-email-iivanov@mm-sol.com>  <1405626085-14069-1-git-send-email-iivanov@mm-sol.com>  <20140722214643.GH19700@sonymobile.com>  <1406119669.28520.10.camel@iivanov-dev> <1406131556.2585.42.camel@iivanov-dev>
In-Reply-To: <1406131556.2585.42.camel@iivanov-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/14 09:05, Ivan T. Ivanov wrote:
>
>> both on
>>> pm8xxx and qpnp-pin there are two different HW blocks, one for GPIO and one for
>>> MPP. And if you look in your pinconf_set function you will see that they are
>>> very different.
> I bet that the hardware blocks are almost identical, just register
> map is different.

The hardware is different and not "almost identical". If it was the same
then we would have called them all GPIOs or MPPs and not had a distinction.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

