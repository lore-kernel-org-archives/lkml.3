Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbaFYO34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:29:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58379 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396AbaFYO3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:29:55 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AADCD7.1010908@roeck-us.net>
Date: Wed, 25 Jun 2014 07:29:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atx.name>, lm-sensors@lm-sensors.org
CC: jdelvare@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (emc1403) Fix missing 'select REGMAP_I2C' in Kconfig
References: <20140625142121.GA14873@dashie>
In-Reply-To: <20140625142121.GA14873@dashie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 07:21 AM, Josef Gajdusek wrote:
> In commit 4cab259f, the emc1403 driver was converted to use regmap but the
> necessary Kconfig option was not added.
>
> Signed-off-by: Josef Gajdusek <atx@atx.name>

Applied.

Thanks,
Guenter

