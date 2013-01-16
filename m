Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab3APIsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:48:41 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52827 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3APIsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:48:40 -0500
Date: Wed, 16 Jan 2013 08:48:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 03/18] power: ab8500_charger: Detect charger removal
Message-ID: <20130116084834.GF9379@gmail.com>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
 <1357909986-9262-4-git-send-email-lee.jones@linaro.org>
 <20130116013640.GA11105@lizard.fhda.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130116013640.GA11105@lizard.fhda.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Anton Vorontsov wrote:

> On Fri, Jan 11, 2013 at 01:12:51PM +0000, Lee Jones wrote:
> > Add two new work queues to provide USB and AC charger disconnect
> > detection.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> [....]
> > +		if ((statval & usbch)) != usbch)
> 
>   CC      drivers/power/ab8500_charger.o
> drivers/power/ab8500_charger.c: In function ‘ab8500_charger_usb_attached_work’:
> drivers/power/ab8500_charger.c:1812:26: error: expected expression before ‘!=’ token
> drivers/power/ab8500_charger.c:1812:34: error: expected statement before ‘)’ token
> drivers/power/ab8500_charger.c: In function ‘ab8500_charger_ac_attached_work’:
> drivers/power/ab8500_charger.c:1852:27: error: expected expression before ‘!=’ token
> drivers/power/ab8500_charger.c:1852:36: error: expected statement before ‘)’ token
> 
> I fixed it up...

You're a star.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
