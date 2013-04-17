Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936148Ab3DQBgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:36:46 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58980 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934423Ab3DQBgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:36:45 -0400
Date: Tue, 16 Apr 2013 18:32:41 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Hongbo Zhang <hongbo.zhang@linaro.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org, dwmw2@infradead.org,
        linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 5/5] hwmon: add ST-Ericsson ABX500 hwmon driver
Message-ID: <20130417013241.GA18418@lizard.mcd26095.sjc.wayport.net>
References: <1364991492-2421-1-git-send-email-hongbo.zhang@linaro.org>
 <1364991492-2421-6-git-send-email-hongbo.zhang@linaro.org>
 <20130403163155.GA18863@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130403163155.GA18863@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 09:31:55AM -0700, Guenter Roeck wrote:
> On Wed, Apr 03, 2013 at 08:18:12PM +0800, Hongbo Zhang wrote:
> > Each of ST-Ericsson X500 chip set series consists of both ABX500 and DBX500
> > chips. This is ABX500 hwmon driver, where the abx500.c is a common layer for
> > all ABX500s, and the ab8500.c is specific for AB8500 chip. Under this designed
> > structure, other chip specific files can be added simply using the same common
> > layer abx500.c.
> > 
> > Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
> 
> Acked-by: Guenter Roeck <linux@roeck-us.net>

Patches 1-5 applied, thanks a lot!

Anton
