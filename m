Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaLRCIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:08:24 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:33009 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaLRCIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:08:22 -0500
MIME-Version: 1.0
In-Reply-To: <5491BA90.9040007@gmail.com>
References: <1418378690-3466-1-git-send-email-lftan@altera.com>
	<548AFDE9.6000909@gmail.com>
	<548F4A99.7040409@ti.com>
	<CAFiDJ5-b9qsLKj8Qh2+yx8_Y1nv5CG1PHyn2Se0zzZLSHWTKNg@mail.gmail.com>
	<5491BA90.9040007@gmail.com>
Date: Thu, 18 Dec 2014 10:08:21 +0800
X-Google-Sender-Auth: lAeegYhdmHj2J6lCm6ZBnH7iAts
Message-ID: <CAFiDJ59FCE1JRHaSRmE06_VWETyONj55dCbFWehV4LoCi4ZLJg@mail.gmail.com>
Subject: Re: [PATCH (resend)] mailbox: Add Altera mailbox driver
From: Ley Foon Tan <lftan@altera.com>
To: Dinh Nguyen <dinh.linux@gmail.com>
Cc: Suman Anna <s-anna@ti.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 1:17 AM, Dinh Nguyen <dinh.linux@gmail.com> wrote:
>>>>> +MODULE_DEVICE_TABLE(of, altera_mbox_match);
>>>>> +
>>>>> +static struct platform_driver altera_mbox_driver = {
>>>>> +    .probe  = altera_mbox_probe,
>>>>> +    .remove = altera_mbox_remove,
>>>>> +    .driver = {
>>>>> +            .name   = DRIVER_NAME,
>>>>> +            .owner  = THIS_MODULE,
>>>>> +            .of_match_table = altera_mbox_match,
>>>
>>> of_match_ptr(altera_mbox_match).
>> Okay.
>
> This driver is DT-only, so of_match_ptr() is not needed.
>
Yes, this driver is DT-only. Okay, we don't need of_match_ptr.

Ley Foon
