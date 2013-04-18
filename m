Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968233Ab3DRKsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:48:16 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:24098 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968220Ab3DRKsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:48:15 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Guenter Roeck <linux@roeck-us.net>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: CodingStyle
Thread-Topic: CodingStyle
Thread-Index: Ac48IAaDW3YOWOBKR5mRpQXBtpPdfw==
Date: Thu, 18 Apr 2013 10:48:06 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191EABF@NB-EX-MBX02.diasemi.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guenter Roeck [mailto:linux@roeck-us.net]
> Sent: 18 April 2013 05:14
> To: Opensource [Anthony Olech]
> Cc: Jean Delvare; Mark Brown; Randy Dunlap; lm-sensors@lm-sensors.org;
> LKML; David Dajun Chen
> Subject: Re: [NEW DRIVER V5 6/7] drivers/hwmon: DA9058 HWMON driver
> 
[...]
> > +	if (cell == NULL) {
> > +		ret = -ENODEV;
> > +		goto exit;
> 
> Just return -ENODEV is good enough here. See CodingStyle, chapter 7.
> 
[...]
> > +exit:
> > +	return ret;
> > +}
[...]

Hi Guenter,

I have read CodingStyle, chapter 7 and it seems to encourage a single exit point from functions.

During development there was some logging done at the (single) exit point but that has been stripped out for submission.
Whilst I can duplicate the logging and do an immediate 'return' at all those points, I am hesitant to do so when chapter 7 of the CodingStyle appears to say to use a single exit point. In addition I had thought that a single exit point from functions was a good thing.

Tony Olech


