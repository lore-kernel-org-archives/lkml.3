Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaK0KTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:19:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaK0KTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:19:01 -0500
Date: Thu, 27 Nov 2014 11:18:56 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Benoit Cousson <bcousson@baylibre.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case
 of configuration errors
Message-ID: <20141127111856.5b6fda60@endymion.delvare>
In-Reply-To: <54762443.90701@roeck-us.net>
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>
	<5474A72D.2000309@roeck-us.net>
	<CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>
	<5474B564.9080902@roeck-us.net>
	<CAMpxmJVGE444t3gE-=u8kuK_B9rJ=0fw9ZYVuYgQRPdswiPj7Q@mail.gmail.com>
	<5474C36C.1020004@roeck-us.net>
	<CAMpxmJUhpX+AAmOS2gcgtJGr0dkeQ7YRyae12oRoW2NkT5drBA@mail.gmail.com>
	<5474CAC6.8030608@roeck-us.net>
	<54754364.80705@roeck-us.net>
	<54759F8A.20303@baylibre.com>
	<54762443.90701@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 11:04:35 -0800, Guenter Roeck wrote:
> On 11/26/2014 01:38 AM, Benoit Cousson wrote:
> > Unfortunately, that's not dynamic enough for all the use cases we need to support with the probes.
> > In fact, most customers will rather put the shunts on their board and thus use a shunt-less version of the probe to do the measurement. In that case, there is no way we can hard code, even in a DTS, the shunt value.
> >
> > That's for that kind of usage that we do need to be able to set the shunt value at runtime. The probe in that case can be pluged dynamically on different board jumpers to do the measurement.
> >
> > Later, thanks to the web UI, the user will be able to configure the shunt value based on the way they were plugged to its boards.
> >
> > sysfs seems to be the easiest way to do that. I don't think DT overlay can handle that, since it is depend of the targeted system and not on the measurement system.
> >
> 
> I just noticed that you did not copy the lm-sensors mailing list.
> 
> I am not really happy with this, and want to get some more feedback
> from the list before I accept more or less arbitrary attributes.
> Jean, any comments ?

No opinion on the matter, sorry.

-- 
Jean Delvare
SUSE L3 Support
