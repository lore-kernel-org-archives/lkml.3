Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3C3X1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 19:27:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49482 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab3C3X1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 19:27:24 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 30 Mar 2013 16:27:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Jean Delvare <khali@linux-fr.org>, Hongbo Zhang <hongbo.zhang@linaro.org>,
        lm-sensors@lm-sensors.org, dwmw2@infradead.org,
        linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 5/5] hwmon: add ST-Ericsson ABX500 hwmon driver
Message-ID: <20130330232726.GB12864@roeck-us.net>
References: <1364368412-12810-1-git-send-email-hongbo.zhang@linaro.org>
 <1364368412-12810-6-git-send-email-hongbo.zhang@linaro.org>
 <20130327194807.GB11086@roeck-us.net>
 <20130330231818.GA30901@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130330231818.GA30901@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 04:18:18PM -0700, Anton Vorontsov wrote:
> On Wed, Mar 27, 2013 at 12:48:07PM -0700, Guenter Roeck wrote:
> > On Wed, Mar 27, 2013 at 03:13:32PM +0800, Hongbo Zhang wrote:
> > > Each of ST-Ericsson X500 chip set series consists of both ABX500 and DBX500
> > > chips. This is ABX500 hwmon driver, where the abx500.c is a common layer for
> > > all ABX500s, and the ab8500.c is specific for AB8500 chip. Under this designed
> > > structure, other chip specific files can be added simply using the same common
> > > layer abx500.c.
> > > 
> > > Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
> > 
> > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> 
> Thanks a lot for your reviews, Guenter!
> 
> Guenter, Jean,
> 
> As the driver depends on the battery driver changes, do you mind if I take
> it via battery-2.6.git tree?
> 
Ok with me. I actually assumed it would be merged through another tree because
of its dependencies.

Guenter
