Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3EXOMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:12:36 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:52940 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3EXOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:12:35 -0400
Message-ID: <519F754F.50908@atmel.com>
Date: Fri, 24 May 2013 16:12:31 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>
CC: Joachim Eastwood <manabian@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/dt: add pinctrl definition for at91 tc blocks
References: <1369389956-30466-1-git-send-email-b.brezillon@overkiz.com> <20130524140528.GE24476@game.jcrosoft.org>
In-Reply-To: <20130524140528.GE24476@game.jcrosoft.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/2013 16:05, Jean-Christophe PLAGNIOL-VILLARD :
> On 12:05 Fri 24 May     , Boris BREZILLON wrote:
>> Hello,
>>
>> This patch adds pinctrl configs for at91 Timer Conter blocks.
>> These pin configs will be referenced by "atmel,tcb-pwm" devices to
>> setup pins as PWM output.
>
> you need to rebase on
>
> a cleanup I did preset on our git tag at91-3.11-cleanup
>
> As we announce Mandaotory for 3.11
>
> as I introduce Macro fro DT

Boris, Hold on.

I may have the solution for you. Give me some time and we may have the 
automatic generation for updating your patch.

Bye,
-- 
Nicolas Ferre
