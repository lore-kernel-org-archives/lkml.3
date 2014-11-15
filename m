Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaKOPUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 10:20:50 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62126 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaKOPUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 10:20:49 -0500
MIME-Version: 1.0
In-Reply-To: <54674EC5.1050506@linux.intel.com>
References: <1416050840-24721-1-git-send-email-dbaryshkov@gmail.com>
	<54674EC5.1050506@linux.intel.com>
Date: Sat, 15 Nov 2014 19:20:48 +0400
Message-ID: <CALT56yMNSNBWWtrR1jmjcncBFO0tGBJSoaveTFTaYO=iKvvgVA@mail.gmail.com>
Subject: Re: [PATCH] genirq: Add IRQ 0 to domain debug file
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2014-11-15 16:01 GMT+03:00 Jiang Liu <jiang.liu@linux.intel.com>:
> On 2014/11/15 19:27, Dmitry Eremin-Solenikov wrote:
>> Currently irq_domain_mapping debugfs file dumps IRQ information starting
>> from IRQ 1. IRQ 0 is missing from that file. Add it to have the complete
>> picture of IRQ/domains mappings.
> Hi Dmitry,
>         For most irqdomain interfaces, they treat irq0 as invalid
> interrupt. But on x86, it's possible to use irq0 for timer. It causes
> may confusion when enabling irqdomain for x86.

I encountered with this issue when enabling IRQ domains support for
one of ARM sub-architectures.

-- 
With best wishes
Dmitry
