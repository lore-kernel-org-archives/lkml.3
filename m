Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbbATSGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:06:50 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42840 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbATSGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:06:25 -0500
Subject: Re: [PATCH] of: Custom printk format specifier for device node
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=windows-1252
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <1421776794.2724.1.camel@perches.com>
Date: Tue, 20 Jan 2015 20:06:15 +0200
Cc: Rob Herring <robherring2@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B282C7F7-D221-4D7D-AB33-533C0204C4CF@konsulko.com>
References: <1421764441-11928-1-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqLVJjq3Ov=J-5LtXiTQPLvR5Y=+tB1i16k_rN3j5dODFQ@mail.gmail.com> <E7065DB3-DD6B-4110-A066-8C7268186831@konsulko.com> <1421776794.2724.1.camel@perches.com>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> On Jan 20, 2015, at 19:59 , Joe Perches <joe@perches.com> wrote:
> 
> On Tue, 2015-01-20 at 16:52 +0200, Pantelis Antoniou wrote:
>> Hi Rob,
>> 
>>> On Jan 20, 2015, at 16:47 , Rob Herring <robherring2@gmail.com> wrote:
>>> 
>>> On Tue, Jan 20, 2015 at 8:34 AM, Pantelis Antoniou
>>> <pantelis.antoniou@konsulko.com> wrote:
>>>> 90% of the usage of device node's full_name is printing it out
>>>> in a kernel message. Preparing for the eventual delayed allocation
>>>> introduce a custom printk format specifier that is both more
>>>> compact and more pleasant to the eye.
> []
>>>> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> []
>>>> +Device tree nodes:
>>>> +
>>>> +       %pO{,1,2}
>>> 
>>> 'O' is not very obvious, but I imagine we are somewhat limted in our
>>> choice here?
>>> 
>> 
>> All the good women are married, all the handsome men are gay, all the obvious
>> format specifiers are taken.
> 
> Not really at all.
> 
> I quite dislike '0' as the format type specifier for
> a device tree node as there's no mnemonic mapping.
> 

There’s only so many characters one can use; [DdNn] are taken. And it’s O != 0.

I am open to suggestions.

Regards

— Pantelis

