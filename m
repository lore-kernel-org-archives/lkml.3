Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaBLJeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:34:09 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63550 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaBLJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:34:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140212083110.GL15081@lee--X1>
References: <1392188969-18486-1-git-send-email-lpapp@kde.org>
	<20140212083110.GL15081@lee--X1>
Date: Wed, 12 Feb 2014 09:34:05 +0000
X-Google-Sender-Auth: K9tc7WgsezbsxwrdJNBl4La85p4
Message-ID: <CAOMwXhOtyg87pMmdKc1ZCWwH_H9D7HLkYdm8UxtJAkONdw8==Q@mail.gmail.com>
Subject: Re: [PATCH v7] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 8:31 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
>> chip includes fan-speed regulators and monitors, GPIO, and alarm.
>>
>> This patch is an initial release of a MAX6650/6651 MFD driver that
>> supports to enable the chip with its primary I2C bus that will connect
>> the hwmon, and then the gpio devices for now.
>>
>> Signed-off-by: Laszlo Papp <lpapp@kde.org>
>> ---
>>  drivers/mfd/Kconfig                 | 11 +++++
>>  drivers/mfd/Makefile                |  1 +
>>  drivers/mfd/max665x.c               | 93 +++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/max665x-private.h | 34 ++++++++++++++
>>  4 files changed, 139 insertions(+)
>>  create mode 100644 drivers/mfd/max665x.c
>>  create mode 100644 include/linux/mfd/max665x-private.h
>
> Applied, thanks.

Thanks (partial celebration time).
