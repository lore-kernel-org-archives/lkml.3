Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936178Ab3DRQG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:06:26 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:61891 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476Ab3DRQGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:06:24 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Guenter Roeck <linux@roeck-us.net>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: CodingStyle
Thread-Topic: CodingStyle
Thread-Index: Ac48IAaDW3YOWOBKR5mRpQXBtpPdfwAEg8qAAAcBboA=
Date: Thu, 18 Apr 2013 16:06:15 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191EBA0@NB-EX-MBX02.diasemi.com>
References: <24DF37198A1E704D9811D8F72B87EB514191EABF@NB-EX-MBX02.diasemi.com>
 <20130418134145.GB2767@roeck-us.net>
In-Reply-To: <20130418134145.GB2767@roeck-us.net>
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
> Sent: 18 April 2013 14:42
> To: Opensource [Anthony Olech]
> Cc: LKML
> Subject: Re: CodingStyle
> 
> On Thu, Apr 18, 2013 at 10:48:06AM +0000, Opensource [Anthony Olech]
> wrote:
> > > -----Original Message-----
> > > From: Guenter Roeck [mailto:linux@roeck-us.net]
> > > Sent: 18 April 2013 05:14
> > > To: Opensource [Anthony Olech]
> > > Cc: Jean Delvare; Mark Brown; Randy Dunlap;
> > > lm-sensors@lm-sensors.org; LKML; David Dajun Chen
> > > Subject: Re: [NEW DRIVER V5 6/7] drivers/hwmon: DA9058 HWMON driver
> > >
> > [...]
> > > > +	if (cell == NULL) {
> > > > +		ret = -ENODEV;
> > > > +		goto exit;
> > >
> > > Just return -ENODEV is good enough here. See CodingStyle, chapter 7.
> > >
> > [...]
> > > > +exit:
> > > > +	return ret;
> > > > +}
> > [...]
> >
> > Hi Guenter,
> >
> > I have read CodingStyle, chapter 7 and it seems to encourage a single exit
> point from functions.
> >
> Yes, unless you can return directly. There is even an example.
> It actually says "... and some common work such as cleanup has to be done".

OK, thank you for clarifying that. I will make the necessary changes.
 
> > During development there was some logging done at the (single) exit point
> but that has been stripped out for submission.
> > Whilst I can duplicate the logging and do an immediate 'return' at all those
> points, I am hesitant to do so when chapter 7 of the CodingStyle appears to say
> to use a single exit point. In addition I had thought that a single exit point from
> functions was a good thing.
> >
> Not if you add a goto to a return statement. That defeats the purpose of easy
> readability.
> Guenter
