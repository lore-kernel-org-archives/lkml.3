Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab3G3Hep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:34:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:53965 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3G3Hen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:34:43 -0400
Message-ID: <51F76C90.90207@linutronix.de>
Date: Tue, 30 Jul 2013 09:34:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, george.cherian@ti.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: phy: rename nop_usb_xceiv => usb_phy_gen_xceiv
References: <1374869757-923-1-git-send-email-bigeasy@linutronix.de> <1374869757-923-2-git-send-email-bigeasy@linutronix.de> <20130729122022.GF24801@radagast> <20130730070814.GF7656@atomide.com>
In-Reply-To: <20130730070814.GF7656@atomide.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 09:08 AM, Tony Lindgren wrote:
> Looking at this patch there's a pretty high probability of introducing
> pointless merge conflicts.
> 
> How about do the platform data related changes as a separate follow-up
> series? You can typically do this by keeping the old features around,
> then doing a separate series to rename or remove the users later on.
> This will remove the dependency between platform data and the driver
> changes.

I can do this. This will work of for the driver name but not for the
name the platform_data struct. To address this part you could create a
separate branch on top of -rc3 or so which contains only this change(s)
and Felipe and you merge this branch so there won't be any conflicts.

> 
> Regards,
> 
> Tony

Sebastian
