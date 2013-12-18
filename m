Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3LRLMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:12:40 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37383 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3LRLMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:12:38 -0500
Date: Wed, 18 Dec 2013 11:12:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Simple MFD driver example
Message-ID: <20131218111232.GE14274@lee--X1>
References: <CAOMwXhN5UfR=Y8V3i=A2zSCv7V9sRDd0Z+D1AQFahvRS-mV5Fw@mail.gmail.com>
 <20131216082556.GE18769@lee--X1>
 <CAOMwXhN8fG8YbU53A_U_MyMTyGWfV7NCCtr2a5oCbHdB0iqqmA@mail.gmail.com>
 <20131216150514.GN18769@lee--X1>
 <CAOMwXhMn5W76Dp=EFNHaknXCqZ4q4e7fphgtttx+8U=1Fc_DMQ@mail.gmail.com>
 <20131216164844.GS18769@lee--X1>
 <CAOMwXhPLNVKbRqR2tPQc758zLsh0Lg0D6JUf2yrf+ZosJVANAw@mail.gmail.com>
 <20131218091609.GB14274@lee--X1>
 <CAOMwXhOSpnEiDoyXNPmy0Gt1tLiwdzGRqoseKqtAUogLEfkCZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhOSpnEiDoyXNPmy0Gt1tLiwdzGRqoseKqtAUogLEfkCZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The MAX6650/6651 chip has multiple functionality:
> 
> * fan/hwmon
> 
> * gpio
> 
> * alarm, etc.
> 
> What you eventually see in hwmon is only a subset of all the features
> the IC provides. You may want to read this thread:
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg536509.html

Okay, so the best thing to do is send out the entire patch-set at
once, CC'ing each of the maintainers on every patch so we can all see
how this thing fits together.

Don't forget to create a cover-letter and each patch should be
in-reply to the cover letter. If you haven't done this before,
practise by sending it to yourself until it looks correct rather than
spamming the list.

It should look like this on this list:

[PATCH 00/03] Subject ...
 |-> [PATCH 01/03] mfd: Description ...
 |-> [PATCH 02/03] hwmon: Description ...
 |-> [PATCH 03/03] gpio: Description ...


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
