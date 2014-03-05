Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaCESDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:03:05 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40598 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaCESDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:03:03 -0500
Message-ID: <531774E9.2000501@cogentembedded.com>
Date: Wed, 05 Mar 2014 22:03:05 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] irq-gic: remove file name from heading comment
References: <201312140224.53928.sergei.shtylyov@cogentembedded.com> <52D5CCFB.1090205@cogentembedded.com> <53166B67.2060804@cogentembedded.com> <alpine.DEB.2.02.1403050112180.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403050112180.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/05/2014 03:27 AM, Thomas Gleixner wrote:

>>>> File names in the heading comments  fell out of favor long ago, and this
>>>> one
>>>> weren't even changed when the driver was moved from arch/arm/common/, so
>>>> remove
>>>> it at last...

>>>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>>>> ---
>>>> The patch is against the 'irq/core' branch of the 'tip.git' repo.

>>>      Thomas, is there a chance that you merge this patch for 3.14? Is it even
>>> the right branch for cleanups (I'm seeing fixes there)?

>>     Thomas, will you ever reply to me? Who's maintaining the GIC driver, you?
>> Or the patches shoud just go in via arm-soc.git?

> That patch is so important^Wtrivial that it really can go via the
> obvious trivial@kernel.org

    I've never been redirected to trivial. I thought only typo fixes and such 
go there. The question is why it did take so long to tell me to do this...

> Sigh....

    Yes... thanks anyway, I'll try sending to trivial.

WBR, Sergei

