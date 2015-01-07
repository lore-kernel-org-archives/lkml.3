Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbbAGQZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:25:52 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35049 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAGQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:25:50 -0500
MIME-Version: 1.0
In-Reply-To: <20150107161638.GA9012@roeck-us.net>
References: <1420634769-11246-1-git-send-email-bgolaszewski@baylibre.com>
	<54AD3325.6030301@roeck-us.net>
	<CAMpxmJUgXyML4o3ya6ofogjf8KMrdPV-Y6SD=ZfUCjt=xLfGiA@mail.gmail.com>
	<20150107161638.GA9012@roeck-us.net>
Date: Wed, 7 Jan 2015 17:25:49 +0100
Message-ID: <CAMpxmJVrbOnjF3me-qyjKqWSxTkQ1=eHdxxsOd7KixVdDGzGoA@mail.gmail.com>
Subject: Re: [PATCH] hwmon: ina2xx: allow to change the averaging rate at run-time
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

2015-01-07 17:16 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> INA219 uses the same mechanism and timing as used by INA209. This way
> it is easily possible to extend the driver to support the attribute
> for every chip. But overall this uses the existing ABI (update_interval
> is part of the hwmon ABI) instead of creating a new driver specific
> attribute. Yes, that is quite important.
>
> The additional "overhead" is just to use different numbers and a
> different attribute name, so I don't really understand your concern.

My concern is that it seems less clear this way, but I understand the
priorities. Ok, I'll get back to it tomorrow.

Bart
