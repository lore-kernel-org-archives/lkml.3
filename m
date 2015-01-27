Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbbA0BXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:23:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47977 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbA0BXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:23:44 -0500
Message-ID: <54C6E89E.2050701@codeaurora.org>
Date: Mon, 26 Jan 2015 17:23:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH] pinctrl: qcom: enable generic support and input-enable
 pinctrl conf
References: <1422289494-31461-1-git-send-email-svarbanov@mm-sol.com> <54C6E753.606@codeaurora.org>
In-Reply-To: <54C6E753.606@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/15 17:18, Stephen Boyd wrote:
> On 01/26/15 08:24, Stanimir Varbanov wrote:
>
>>  		return -ENOTSUPP;
>>  	}
>>  
>> @@ -208,14 +208,12 @@ static int msm_config_get(struct pinctrl_dev *pctldev,
>>  			  unsigned int pin,
>>  			  unsigned long *config)
>>  {
>> -	dev_err(pctldev->dev, "pin_config_set op not supported\n");
> Same for here.
>
>>  	return -ENOTSUPP;
>>  }
>>  
>>  static int msm_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
>>  				unsigned long *configs, unsigned num_configs)
>>  {
>> -	dev_err(pctldev->dev, "pin_config_set op not supported\n");
> And here.

Actually it looks like we can just remove these two functions and the
core does the right thing and prints errors. That would be a good patch.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

