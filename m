Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaC2JxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 05:53:06 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50867 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaC2JxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 05:53:03 -0400
Message-ID: <533697F8.5000903@gmail.com>
Date: Sat, 29 Mar 2014 10:52:56 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [RFC PATCH v2 03/10] ARM: at91: introduce OLD_IRQ_AT91 Kconfig
 option
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com> <1396029548-10928-4-git-send-email-b.brezillon.dev@gmail.com> <20140329100639.5ea454bc@skate> <7407417.cSDunZuEhW@wuerfel>
In-Reply-To: <7407417.cSDunZuEhW@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/03/2014 10:12, Arnd Bergmann a écrit :
> On Saturday 29 March 2014 10:06:39 Thomas Petazzoni wrote:
>> Dear Boris BREZILLON,
>>
>> On Fri, 28 Mar 2014 18:59:01 +0100, Boris BREZILLON wrote:
>>
>>> +config OLD_IRQ_AT91
>>> +     bool
>>> +     default false
>> I don't think "default false" is a valid Kconfig construct. It could be
>> "default n", but that's useless since "default n" is the default
>> behavior. So I believe you can simply get rid of that line.

I'll fix it for the next version.

> I think the above is syntactically correct, but it would be highly confusing in
> anyone ever does
>
> config false
> 	def_bool y
>
> ;-)
>
> Aside from that, these three have completely identical meaning:
>
> config OLD_IRQ_AT91
> 	bool
>
> config OLD_IRQ_AT91
> 	def_bool n
>
> config OLD_IRQ_AT91
> 	bool
> 	default n
>
> 	Arnd
>
>
Thanks for the detailled explanation :-).

Best Regards,

Boris
