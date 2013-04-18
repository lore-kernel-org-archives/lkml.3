Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966598Ab3DROTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:19:55 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:20416 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989Ab3DROTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:19:54 -0400
Message-ID: <51700105.9080802@atmel.com>
Date: Thu, 18 Apr 2013 16:19:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Andrew Victor <linux@maxim.org.za>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH 18/19] ARM: at91: suspend both memory controllers on at91sam9263
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359153858-31992-19-git-send-email-arnd@arndb.de> <516FF8FC.7070901@atmel.com> <201304181615.20542.arnd@arndb.de>
In-Reply-To: <201304181615.20542.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 04:15 PM, Arnd Bergmann :
> On Thursday 18 April 2013, Nicolas Ferre wrote:
> 
>>> This patch blindly removes the warning and changes the
>>> at91sam9263 to use the same code at at91sam9g45, which
>>> may or may not be the right solution. If it is not,
>>> maybe someone could provide a better fix.
>>
>> Maybe you can remove this paragraph: now you are using the proper fix
>> with proper RAM type.
>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> What is the future of this patch series: do you want us to take this
>> patch separately or to you want to apply the whole series on the arm-soc
>> tree?
> 
> I'd prefer if you could just apply or forward it to an appropriate tree.
> 
> Most of the other patches have found their way into mainline by now.
> 
>>> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
>>> Cc: Andrew Victor <linux@maxim.org.za>
>>> Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
>>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>>
>> Moreover, this patch my conflict with Daniel's current initiative to
>> move cpuidle driver to its own directory: how do we coordinate with each
>> other?
> 
> Maybe you can make sure it actually works and send it to Daniel to apply on
> top of his other patches?

Well, as Daniel's patches are still under construction, I stack this one
on the at91-3.10-soc branch and let Daniel rebase his work on top of a
3.10-rc1-ish tree...

Best regards,
-- 
Nicolas Ferre
