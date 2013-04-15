Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3DOPBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:01:05 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:14279 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3DOPBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:01:03 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Guenter Roeck <linux@roeck-us.net>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
Thread-Topic: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
Thread-Index: AQHON39CtDkBnJtRskO6UighSEzvVZjShI+AgATexgA=
Date: Mon, 15 Apr 2013 15:00:58 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191E103@NB-EX-MBX02.diasemi.com>
References: <201304121310.r3CDAJHh011814@latitude>
 <20130412133221.GA11293@roeck-us.net>
In-Reply-To: <20130412133221.GA11293@roeck-us.net>
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
> Sent: 12 April 2013 14:32
> To: Opensource [Anthony Olech]
> Cc: Mark Brown; Liam Girdwood; Jean Delvare; Randy Dunlap; LKML; David
> Dajun Chen
> Subject: Re: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
> 
> On Fri, Apr 12, 2013 at 02:05:28PM +0100, Anthony Olech wrote:
> > This is the REGULATOR component driver of the Dialog DA9058 PMIC.
> > This driver is just one component of the whole DA9058 PMIC driver.
> > It depends on the CORE component driver of the DA9058 MFD.
> >
> > There are 6 warnings from scripts/checkpatch.pl, but since it seems to
> > be complaining about variable names such as min_uV are in CamelCase,
> > when it is obvious that they are not in CamelCase I have ignored them.
> >
> ??? min_uV _is_ CamelCase ???
> 
> Ok, maybe it is camelcasE, but you are splitting hairs here.

it is not me splitting hairs, it is scripts/checkpatch.pl

Tony Olech

