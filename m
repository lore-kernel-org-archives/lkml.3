Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbbANXo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:44:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42275 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbbANXo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:44:57 -0500
Message-ID: <54B6FF75.70500@codeaurora.org>
Date: Wed, 14 Jan 2015 15:44:53 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH v3 4/4] pinctrl: qcom: Add support for reset for apq8064
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>	<1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com> <CAOZdJXXRgrYUEcX4f5zRuKgX-Dtbpvf-SV4-8rjuohv3=0NJhQ@mail.gmail.com>
In-Reply-To: <CAOZdJXXRgrYUEcX4f5zRuKgX-Dtbpvf-SV4-8rjuohv3=0NJhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 03:38 PM, Timur Tabi wrote:
> On Fri, Aug 29, 2014 at 9:30 AM, Pramod Gurav
> <pramod.gurav@smartplayin.com> wrote:
>> +static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
>> +{
>> +       int i = 0;
>> +       const struct msm_function *func = pctrl->soc->functions;
>> +
>> +       for (; i <= pctrl->soc->nfunctions; i++)
> Shouldn't this be
>
>             i < pctrl->soc->nfunctions
>
> As it stands, if nfunctions == 0, this function crashes.
>

I think so. Can you send a patch? Plus it would be nice to move i = 0 in
the for loop at the same time.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

