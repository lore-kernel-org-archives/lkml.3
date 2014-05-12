Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbaELRDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:03:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbaELRDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:03:30 -0400
Date: Mon, 12 May 2014 19:03:27 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Josef Gajdusek <atx@atx.name>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add support for emc14x2
Message-ID: <20140512190327.4f65c90a@endymion.delvare>
In-Reply-To: <20140512161415.GA16770@roeck-us.net>
References: <20140512123409.GB16252@dashie>
	<20140512161415.GA16770@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 09:14:15 -0700, Guenter Roeck wrote:
> On Mon, May 12, 2014 at 02:34:09PM +0200, Josef Gajdusek wrote:
> >  static const struct i2c_device_id emc1403_idtable[] = {
> > -	{ "emc1403", 0 },
> > -	{ "emc1404", 1 },
> > -	{ "emc1423", 0 },
> > -	{ "emc1424", 1 },
> > +	{ "emc1402", emc1402 },
> > +	{ "emc1403", emc1403 },
> > +	{ "emc1404", emc1404 },
> > +	{ "emc1422", emc1402 },
> > +	{ "emc1423", emc1403 },
> > +	{ "emc1424", emc1404 },
> 
> Wonder if we should list the emc141x chips here. Jean, any thoughts ?

Yes we should, so that people can declare the right chip in platform
files, device tree etc. We can map the additional names to existing
types if the chips are fully compatible.

-- 
Jean Delvare
SUSE L3 Support
