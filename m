Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaELSrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:47:42 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46728 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaELSrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:47:37 -0400
Date: Mon, 12 May 2014 11:47:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: Josef Gajdusek <atx@atx.name>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add support for emc14x2
Message-ID: <20140512184727.GA9003@roeck-us.net>
References: <20140512123409.GB16252@dashie>
 <20140512161415.GA16770@roeck-us.net>
 <20140512190327.4f65c90a@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512190327.4f65c90a@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 07:03:27PM +0200, Jean Delvare wrote:
> On Mon, 12 May 2014 09:14:15 -0700, Guenter Roeck wrote:
> > On Mon, May 12, 2014 at 02:34:09PM +0200, Josef Gajdusek wrote:
> > >  static const struct i2c_device_id emc1403_idtable[] = {
> > > -	{ "emc1403", 0 },
> > > -	{ "emc1404", 1 },
> > > -	{ "emc1423", 0 },
> > > -	{ "emc1424", 1 },
> > > +	{ "emc1402", emc1402 },
> > > +	{ "emc1403", emc1403 },
> > > +	{ "emc1404", emc1404 },
> > > +	{ "emc1422", emc1402 },
> > > +	{ "emc1423", emc1403 },
> > > +	{ "emc1424", emc1404 },
> > 
> > Wonder if we should list the emc141x chips here. Jean, any thoughts ?
> 
> Yes we should, so that people can declare the right chip in platform
> files, device tree etc. We can map the additional names to existing
> types if the chips are fully compatible.
> 
The chips are not only compatible, the even have the same device IDs.
Maybe I missed it, but I did not find a difference.

I'll add another patch to my list.

Guenter
