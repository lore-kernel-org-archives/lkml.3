Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaELUdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:33:52 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:59316 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaELUdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:33:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140512201517.GC5668@atomide.com>
References: <1399686184-1594-1-git-send-email-mranostay@gmail.com>
	<20140512195050.GB5668@atomide.com>
	<CAOCHtYiYwx_bEsyqkbUTTAbhBYESzvfBOOYeVuFXPS1dDy0ZKA@mail.gmail.com>
	<20140512201517.GC5668@atomide.com>
Date: Mon, 12 May 2014 15:27:13 -0500
Message-ID: <CAOCHtYg6XpF0Gbo4iFqsFvP=QSivQQvCzov8UfxeLXMzrRYEWw@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: dts: am335x-bone-common: Add i2c2 definition
From: Robert Nelson <robertcnelson@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Matt Ranostay <mranostay@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        pantelis.antoniou@gmail.com, matt.porter@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >
>> > If these pins are not used for i2c2 on some capes, this device
>> > should be set to status = "disabled" state by default. Then
>> > u-boot could re-enable it on the boards that have i2c2 in use.
>>
>> To-date, this is the i2c bus that all capes have placed an at24 eeprom
>> for cape identification.
>
> And how many capes actually implement the eeprom cape identification
> out of the available capes? :)

Not including one off designs in someone's lab. We will never have an
accurate number. ;)

So far; just the ones that want their "cape" detected in the default
image currently being shipped by CircuitCo. Otherwise the few that
I've seen without an eeprom, usually follow this default pinmux.

http://elinux.org/CircuitCo:Basic_Proto_Cape

Which includes that i2c bus enabled.

Either case if fine with me.  As who knows when the dtc "overlay" will
every truly make it mainline, as the capemgr was the only real kernel
user of the i2c/at24 eeprom information.

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
