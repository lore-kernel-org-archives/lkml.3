Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3KRXtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:49:21 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64981 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3KRXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:49:18 -0500
MIME-Version: 1.0
In-Reply-To: <5286F41F.6090504@roeck-us.net>
References: <1384549081-9571-1-git-send-email-markus.mayer@linaro.org>
	<1384549081-9571-2-git-send-email-markus.mayer@linaro.org>
	<5286F41F.6090504@roeck-us.net>
Date: Mon, 18 Nov 2013 15:49:16 -0800
Message-ID: <CAPdLdq=vhM_cpFFWZvdX90feJzzwowLRWsSBG5gaPaDdgjUbdw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] watchdog: bcm281xx: Watchdog Driver
From: Markus Mayer <markus.mayer@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, Christian Daudt <bcm@fixthebug.org>,
        Linaro Patches <patches@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2013 20:27, Guenter Roeck <linux@roeck-us.net> wrote:
> On 11/15/2013 12:58 PM, Markus Mayer wrote:
>>
>> This commit adds support for the watchdog timer used on the BCM281xx
>> family of SoCs.
>>
>> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
>
>
> You are using two different e-mail addresses, the one here and the one in
> MODULE_AUTHOR.
> Any chance to use only one ? Of course, there may be a reason, so maybe it
> is ok.

There is indeed reason behind the madness. I am wearing two hats of
sorts. I work for Broadcom, but I am assigned to Linaro, hence the
somewhat adventurous construction with two e-mail addresses.

I addressed your remaining comments and will be sending out v3 of the
patch shortly.

Thanks,
-Markus

-- 
Markus Mayer
Broadcom Landing Team
