Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbaHGIfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:35:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbaHGIfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:35:51 -0400
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: kreijack@inwind.it, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <53E32C77.5000804@roeck-us.net>
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
	 <1407359103-6012-6-git-send-email-kreijack@inwind.it>
	 <20140806231803.GA5643@roeck-us.net>	<53E31694.8050107@gmail.com>
	 <53E31AB0.6070604@roeck-us.net> <20140807085235.2c0e63dd@endymion.delvare>
	 <53E32C77.5000804@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Thu, 07 Aug 2014 10:35:45 +0200
Message-ID: <1407400545.4314.2.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thursday 07 August 2014 à 00:36 -0700, Guenter Roeck a écrit :
> On 08/06/2014 11:52 PM, Jean Delvare wrote:
> > Hi Guenter,
> >
> > On Wed, 06 Aug 2014 23:20:32 -0700, Guenter Roeck wrote:
> >> Patch 4/5 is "Return the fan speed via sysfs: /sys/devices/temperature/fan_level".
> >>
> >> So you are saying that returning the fan speed with a non-hwmon attribute works,
> >> but returning it with a hwmon attribute doesn't ? Not really sure if I understand
> >> your logic. Either fan_level doesn't return the fan speed (or an abstraction of it),
> >> or something in your line of argument is inconsistent.
> >
> > fan_level is a fan speed _control_ value, like pwm1. It is not a fan
> > speed monitoring value.
> >
> Ah, ok. The patch description doesn't seem to match, though.
> And why not export it as pwm1, if that is what it is ?

Well, /sys/devices/temperature is a non-standard interface anyway, so it
does not really matter. I already discussed with Goffredo the
possibility to also expose it as pwm1 on the hwmon side, this might
happen later.

-- 
Jean Delvare
SUSE L3 Support

