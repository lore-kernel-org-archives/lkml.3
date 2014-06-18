Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaFRGl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:41:57 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59748 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbaFRGly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:41:54 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A134A5.9020308@roeck-us.net>
Date: Tue, 17 Jun 2014 23:41:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>, Heiko Schocher <hs@denx.de>,
        lm-sensors@lm-sensors.org
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5] hwmon: Driver for TI TMP103 temperature sensor
References: <1403069837-15651-1-git-send-email-hs@denx.de> <53A127BB.7090802@gmail.com> <53A12DBB.50704@roeck-us.net> <53A12F37.8020206@gmail.com>
In-Reply-To: <53A12F37.8020206@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 11:18 PM, Varka Bhadram wrote:

>>>>   ti,tmp102        Low Power Digital Temperature Sensor with SMBUS/Two Wire Serial Interface
>>>> +ti,tmp103        Low Power Digital Temperature Sensor with SMBUS/Two Wire Serial Interface
> May i know about this binding compatible property ?

At some point someone will have to document how trivial i2c device mappings
work in detail. Every other time another trivial i2c device is added
to this file, the same argument starts all over again.

An attempt to document the trivial i2c device mappings implementation
was rejected with the argument that it would be implementation (Linux)
specific. The proposed patch [1] may however help understanding how
it works.

Hope that helps,
Guenter

---

[1] http://patchwork.ozlabs.org/patch/301938/

