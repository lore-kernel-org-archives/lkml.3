Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806AbaFTIij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:38:39 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:46271 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932937AbaFTIih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:38:37 -0400
Message-ID: <53A3F305.9070903@codethink.co.uk>
Date: Fri, 20 Jun 2014 09:38:29 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linus.walleij@linaro.org, gnurou@gmail.com, lgirdwood@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@codethink.co.uk, ian.molton@codethink.co.uk,
        ben.dooks@codethink.co.uk, heiko@sntech.de
Subject: Re: Change gpio-reulator-probe() to use managed resources.
References: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk> <20140619175745.GS5099@sirena.org.uk>
In-Reply-To: <20140619175745.GS5099@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19/06/14 18:57, Mark Brown wrote:
> On Thu, Jun 19, 2014 at 04:46:01PM +0100, Rob Jones wrote:
>> Add new managed resource functions as needed to achieve this.
>>
>> Amend the following functions:
> You appear to have omitted the actual patch, I'm quoting the entire
> mail here.  Please see Documentation/SubmittingPatches for some tips
> on how to do things.

I omitted to put "[Patch 0/4][v2]" on the front of the subject line.The 
actual patches followed.

It was a consequence of lack of familiarity with the tools; I'm 
learning, so it shouldn't happen again. Would you like me to resubmit?

>
>> devm_kstrdup()
>> gpio_regulator_probe()
>>
>> Add the following functions:
>>
>> devm_kmemdup()
>> devm_gpio_request_array()
>> devm_gpio_free_array()
>>
>> Remove the following functions:
>>
>> gpio_regulator_remove()
>>
>>
>>  From Rob Jones <rob.jones@codethink.co.uk> # This line is ignored.
>> From: Rob Jones <rob.jones@codethink.co.uk>
>> Subject:
>> In-Reply-To:
>>
>>

-- 
Rob Jones
Project Manager
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

