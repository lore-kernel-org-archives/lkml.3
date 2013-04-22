Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3DVBOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 21:14:30 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:10753 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3DVBO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 21:14:29 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Guenter Roeck <linux@roeck-us.net>, Lars-Peter Clausen <lars@metafoo.de>
CC: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>,
        "Jean Delvare" <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [NEW DRIVER V6 6/7] drivers/hwmon: DA9058 HWMON driver
Thread-Topic: [NEW DRIVER V6 6/7] drivers/hwmon: DA9058 HWMON driver
Thread-Index: AQHOPSEubkz3P5Ym/UOAXwYREM+UHZjdy2MAgAGEaoCAAh99gA==
Date: Mon, 22 Apr 2013 01:14:26 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191F1F7@NB-EX-MBX02.diasemi.com>
References: <201304191712.r3JHCEmr017829@latitude>
 <51718BFE.7060409@metafoo.de> <20130420173513.GA8275@roeck-us.net>
In-Reply-To: <20130420173513.GA8275@roeck-us.net>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.95.24.79]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guenter Roeck [mailto:linux@roeck-us.net]
> Sent: 20 April 2013 18:35
> To: Lars-Peter Clausen
> Cc: Opensource [Anthony Olech]; Jean Delvare; Mark Brown; Randy Dunlap;
> lm-sensors@lm-sensors.org; LKML; David Dajun Chen
> Subject: Re: [NEW DRIVER V6 6/7] drivers/hwmon: DA9058 HWMON driver
> On Fri, Apr 19, 2013 at 08:25:02PM +0200, Lars-Peter Clausen wrote:
> > Same comment as before, I'd like to see this using the generic IIO to
> > HWMON bridge instead of recreating it.
> ... and I agree. Seems we are getting more and more of those, and at some
> point it makes really sense to find a generic solution.
> Anthony, can you please look into that ?
> Thanks,
> Guenter

OK -- generic IIO to HWMON bridge

I will investigate - but if you know any prototypes or any useful starting point could you let me know as I don't want to re-invent the wheel.

Thanks,

Anthony Olech
