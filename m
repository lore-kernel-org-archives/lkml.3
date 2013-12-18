Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3LRB0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:26:08 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:39106 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828Ab3LRBZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:25:46 -0500
Message-ID: <52B0F888.2000905@atmel.com>
Date: Wed, 18 Dec 2013 09:21:12 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: <linux-pwm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <galak@codeaurora.org>,
        <plagnioj@jcrosoft.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 0/2] PWM: pwm-atmel: add PWM controller driver
References: <1386916910-24832-1-git-send-email-voice.shen@atmel.com> <20131217103034.GE13823@ulmo.nvidia.com>
In-Reply-To: <20131217103034.GE13823@ulmo.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 12/17/2013 06:30 PM, Thierry Reding wrote:
> On Fri, Dec 13, 2013 at 02:41:48PM +0800, Bo Shen wrote:
>> This patch series add Atmel PWM controller driver support.
>>
>> Changes in v9:
>>    - Address the comments from Thierry Reding
>
> Hi,
>
> I've pushed a slightly modified version of this series. There were a few
> minor whitespace/coding style issues, but perhaps more importantly I've
> modified the period change check to be done earlier and in a more
> generic way.

Thanks for your work.

> Can you please check that the version I've pushed to the for-next branch
> still works for you?

Tested OK with pwm leds and pwm backlight.
Thanks again.

> Thanks,
> Thierry

Best Regards,
Bo Shen
