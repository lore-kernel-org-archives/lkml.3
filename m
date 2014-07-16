Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbaGPMZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:25:36 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:52707 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961AbaGPMZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:25:34 -0400
Message-ID: <53C66F3B.9020507@mm-sol.com>
Date: Wed, 16 Jul 2014 15:25:31 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: pramod.gurav.etc@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Josh Cartwright <joshc@codeaurora.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is selected
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>  <53C66AEB.7030906@mm-sol.com> <1405512867.75389776@apps.rackspace.com>
In-Reply-To: <1405512867.75389776@apps.rackspace.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

>>>
>>>  config REGMAP_SPMI
>>> +	select SPMI
>>
>> NO, IMO the CONFIG_SPMI should be enabled by qcom_defconfig and
>> multi_v7_defconfig. See CONFIG_I2C and REGMAP_I2C for example.
>>
> 
> I am using multi_v7_defconfig but its not enabling it. I ran qcom_defconfig which does.

yes, it seems reasonable to add it in multi_v7_defconfig also.


-- 
regards,
Stan
