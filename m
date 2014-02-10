Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaBJNeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:34:25 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53488 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaBJNeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:34:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhMJTeO8ev++dzXKtz8En9pK+3CkjmweuLsb5aoU+e=Aqw@mail.gmail.com>
References: <1392019497-12440-1-git-send-email-lpapp@kde.org>
	<20140210112242.GB21522@lee--X1>
	<CAOMwXhMJTeO8ev++dzXKtz8En9pK+3CkjmweuLsb5aoU+e=Aqw@mail.gmail.com>
Date: Mon, 10 Feb 2014 13:34:11 +0000
X-Google-Sender-Auth: yDzza8yWc5eheQV86soqBl7aLxQ
Message-ID: <CAOMwXhMriMiS9Pvm210BB0ScRJUw-whC2rnN+Ka383ztuSvOJQ@mail.gmail.com>
Subject: Re: [PATCH v3] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +};
>>> +MODULE_DEVICE_TABLE(i2c, max665x_id);
>>> +
>>> +static struct i2c_driver max665x_driver = {
>>> +     .driver = {
>>> +             .name = "max665x",
>>> +             .owner = THIS_MODULE,
>>
>> All new drivers are required to support Device Tree.
>
> Do you have some recommendation for documentation, examples, etc? I am
> new to this.

I see .of_match_table added in certain mfd drivers, but I am not sure
what I should put into the name or even the compatible member, I see
them boot neglected in various drivers. The structure here does not
seem to be documented either:
http://lxr.free-electrons.com/source/include/linux/mod_devicetable.h#L220

I do not know where to get the information for the .name and/or
.compatible entry for, or if I need anything more.
