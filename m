Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbbAHSOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:14:06 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35497 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbbAHSOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:14:04 -0500
MIME-Version: 1.0
In-Reply-To: <20150108170519.GA30248@roeck-us.net>
References: <1420734313-24546-1-git-send-email-bgolaszewski@baylibre.com>
	<20150108170519.GA30248@roeck-us.net>
Date: Thu, 8 Jan 2015 19:14:02 +0100
Message-ID: <CAMpxmJVmyVr7PJGaAkujacpWyRXew=37bz-PsURf7_-dTptBSw@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (ina2xx) implement update_interval attribute for ina226
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-08 18:05 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> What is the purpose of multiplying the calculated average by 2 ?

The comment above says:

> +     /*
> +      * Add bus and shunt voltage conversion times and multiple them
> +      * by the averaging rate. Return the result in milliseconds.
> +      */

Since both conversion times are the same and equal
INA226_CONV_TIME_DEFAULT I just multiplied it by 2 - I thought it was
clear enough. I'll fix that in the next iteration.

Bart
