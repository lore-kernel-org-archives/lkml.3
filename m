Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3DOR3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:29:18 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:17486 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3DOR3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:29:17 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Guenter Roeck <linux@roeck-us.net>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
Thread-Topic: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
Thread-Index: AQHON39CtDkBnJtRskO6UighSEzvVZjShI+AgATexgCAAAtnAIAAHWjg
Date: Mon, 15 Apr 2013 17:29:13 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191E14C@NB-EX-MBX02.diasemi.com>
References: <201304121310.r3CDAJHh011814@latitude>
 <20130412133221.GA11293@roeck-us.net>
 <24DF37198A1E704D9811D8F72B87EB514191E103@NB-EX-MBX02.diasemi.com>
 <20130415163532.GA24272@roeck-us.net>
In-Reply-To: <20130415163532.GA24272@roeck-us.net>
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
> Sent: 15 April 2013 17:36
> To: Opensource [Anthony Olech]
> Cc: LKML
> Subject: Re: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
> 
> On Mon, Apr 15, 2013 at 03:00:58PM +0000, Opensource [Anthony Olech]
> wrote:
> >
> >
> > > -----Original Message-----
> > > From: Guenter Roeck [mailto:linux@roeck-us.net]
> > > Sent: 12 April 2013 14:32
> > > To: Opensource [Anthony Olech]
> > > Cc: Mark Brown; Liam Girdwood; Jean Delvare; Randy Dunlap; LKML;
> > > David Dajun Chen
> > > Subject: Re: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
> > >
> > > On Fri, Apr 12, 2013 at 02:05:28PM +0100, Anthony Olech wrote:
> > > > This is the REGULATOR component driver of the Dialog DA9058 PMIC.
> > > > This driver is just one component of the whole DA9058 PMIC driver.
> > > > It depends on the CORE component driver of the DA9058 MFD.
> > > >
> > > > There are 6 warnings from scripts/checkpatch.pl, but since it
> > > > seems to be complaining about variable names such as min_uV are in
> > > > CamelCase, when it is obvious that they are not in CamelCase I have
> ignored them.
> > > >
> > > ??? min_uV _is_ CamelCase ???
> > >
> > > Ok, maybe it is camelcasE, but you are splitting hairs here.
> >
> > it is not me splitting hairs, it is scripts/checkpatch.pl
> >
> Maybe you did not understand what I meant. Per your logic,
> 
> 	MicroVolt is CamelCase
> 	uVolt is ???
> 	uV is not CamelCase
> 
> By abbreviating CamelCase to camelCase to cC you make it, in your opinion,
> acceptable.
> 
> If you want to declare CamelCase variables, just do it, but don't claim that they
> are not really CamelCase.
> 
> Guenter

I always thought that camel case meant "changing from lower case to upper case the first 
letter of each word and then joining the capitalized words together", so by that definition
uV or mW are not camel case because "v" and "w" are not words!

Either way it seems that the algorithm in scripts/checkpatch.pl is wrong! and that was my point.

Tony Olech

