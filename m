Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3GFUOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 16:14:38 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40446 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3GFUOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 16:14:35 -0400
Date: Sat, 6 Jul 2013 13:14:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] hwmon: (ds1621) Convert to use
 hwmon_device_register_groups
Message-ID: <20130706201432.GB15473@roeck-us.net>
References: <1373131495-13465-1-git-send-email-linux@roeck-us.net>
 <1373131495-13465-4-git-send-email-linux@roeck-us.net>
 <20130706175747.GA8658@kroah.com>
 <20130706200151.70b7ac3d@endymion.delvare>
 <20130706191816.GA15066@roeck-us.net>
 <20130706193142.GA9778@kroah.com>
 <20130706194803.GA15473@roeck-us.net>
 <20130706215957.70ae1fdc@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130706215957.70ae1fdc@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 09:59:57PM +0200, Jean Delvare wrote:
> On Sat, 6 Jul 2013 12:48:03 -0700, Guenter Roeck wrote:
> > Another option would be to create a class attribute to return the parent driver
> > name for spi and i2c devices and otherwise the hwmon driver name. This would
> > reduce the amount of code needed in the drivers. Jean, do you see a problem with
> > that approach (except that we would have to remove explicit name attributes from
> > existing drivers) ?
> 
> A class attribute is what I had in mind in my previous reply. However I
> do not understand the "hwmon driver name" in your sentence above.

s/driver/device/

> Device name != driver name. But well I'm sure I'll understand what you
> mean as soon as you show us a candidate implementation ;)
> 
Guess so :)

Guenter
