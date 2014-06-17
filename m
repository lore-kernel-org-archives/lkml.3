Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbaFQPgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:36:16 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:40822 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932999AbaFQPgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:36:14 -0400
Message-ID: <53A0606C.6030400@dev.rtsoft.ru>
Date: Tue, 17 Jun 2014 19:36:12 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH 11/21] mfd: use devm_irq_of_parse_and_map() where appropriate
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru> <1401880402-30091-12-git-send-email-nyushchenko@dev.rtsoft.ru> <20140617151226.GM29841@lee--X1>
In-Reply-To: <20140617151226.GM29841@lee--X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

17.06.2014 19:12, Lee Jones пишет:
>> From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
>>
>> This avoids leak of IRQ mapping on error paths, and makes it possible
>> to use devm_request_irq() without facing unmap-while-handler-installed
>> issues.
>>
>> Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
>> ---
>>   drivers/mfd/max8997.c |    4 +++-
>>   drivers/mfd/max8998.c |    4 +++-
>>   2 files changed, 6 insertions(+), 2 deletions(-)
>
> Applied, thanks.

Hmm...  probably it was too early to apply this?  I was just going to 
prepare v2, based on discussion...

Also, applying only 11/21, without 01/21, will just cause build errors ...

Confused.

Nikita
