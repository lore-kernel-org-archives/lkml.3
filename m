Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab3BZTle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:41:34 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50773 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867Ab3BZTld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:41:33 -0500
X-Originating-IP: 108.223.40.66
Date: Tue, 26 Feb 2013 11:41:33 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Joe Perches <joe@perches.com>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/12] hwmon: (nct6775) Add support for temperature
 sensors
Message-ID: <20130226194133.GA6240@roeck-us.net>
References: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
 <1361903020-18526-4-git-send-email-linux@roeck-us.net>
 <1361903714.2023.19.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361903714.2023.19.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:35:14AM -0800, Joe Perches wrote:
> On Tue, 2013-02-26 at 10:23 -0800, Guenter Roeck wrote:
> > diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
> []
> > +static const u16 NCT6779_REG_TEMP_CONFIG[11] = { 0x18, 0x152 };
> 
> Isn't 11 too magic a number?
> 
Yes; good catch.

It actually doesn't need a size in the first place, as long as it has
(at least) the same size as NCT677x_REG_TEMP. Must be a leftover from
an earlier version of the code.

Thanks,
Guenter
