Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3DOQfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:35:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60937 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3DOQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:35:16 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 15 Apr 2013 09:35:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
Message-ID: <20130415163532.GA24272@roeck-us.net>
References: <201304121310.r3CDAJHh011814@latitude>
 <20130412133221.GA11293@roeck-us.net>
 <24DF37198A1E704D9811D8F72B87EB514191E103@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB514191E103@NB-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 03:00:58PM +0000, Opensource [Anthony Olech] wrote:
> 
> 
> > -----Original Message-----
> > From: Guenter Roeck [mailto:linux@roeck-us.net]
> > Sent: 12 April 2013 14:32
> > To: Opensource [Anthony Olech]
> > Cc: Mark Brown; Liam Girdwood; Jean Delvare; Randy Dunlap; LKML; David
> > Dajun Chen
> > Subject: Re: [NEW DRIVER V4 7/7] DA9058 REGULATOR driver
> > 
> > On Fri, Apr 12, 2013 at 02:05:28PM +0100, Anthony Olech wrote:
> > > This is the REGULATOR component driver of the Dialog DA9058 PMIC.
> > > This driver is just one component of the whole DA9058 PMIC driver.
> > > It depends on the CORE component driver of the DA9058 MFD.
> > >
> > > There are 6 warnings from scripts/checkpatch.pl, but since it seems to
> > > be complaining about variable names such as min_uV are in CamelCase,
> > > when it is obvious that they are not in CamelCase I have ignored them.
> > >
> > ??? min_uV _is_ CamelCase ???
> > 
> > Ok, maybe it is camelcasE, but you are splitting hairs here.
> 
> it is not me splitting hairs, it is scripts/checkpatch.pl
> 
Maybe you did not understand what I meant. Per your logic,

	MicroVolt is CamelCase
	uVolt is ???
	uV is not CamelCase

By abbreviating CamelCase to camelCase to cC you make it,
in your opinion, acceptable.

If you want to declare CamelCase variables, just do it,
but don't claim that they are not really CamelCase.

Guenter
