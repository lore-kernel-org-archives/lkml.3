Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbbAIOp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:45:29 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:44724 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAIOp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:45:28 -0500
MIME-Version: 1.0
In-Reply-To: <54AFE6E3.4050603@roeck-us.net>
References: <1420804980-11637-1-git-send-email-bgolaszewski@baylibre.com>
	<54AFE6E3.4050603@roeck-us.net>
Date: Fri, 9 Jan 2015 15:45:27 +0100
Message-ID: <CAMpxmJV7O_DqTx66N5t2dWc8JqpqFmvQS+figEOVm9P4DYoZNg@mail.gmail.com>
Subject: Re: [PATCHv2] hwmon: (ina2xx) implement update_interval attribute for ina226
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

2015-01-09 15:34 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> Unfortunately that only applies to INA226 and not INA219, where the time is
> static
> (at least so far).

Oops, I must have missed this one.

> I think we'll need to store the time in ina2xx_data and use the old
> (constant)
> value for ina219. Maybe add another variable into the configuration data
> for the initial value and copy it from there during probe.

I tried to avoid adding another variable used by ina226 only, but
well. It's kind of dull that these chips are supported by a single
driver - their configuration register layout is completely different.

Bart
