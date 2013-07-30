Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab3G3J51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:57:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:55126 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651Ab3G3J5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:57:23 -0400
Message-ID: <51F78DFF.2030307@linutronix.de>
Date: Tue, 30 Jul 2013 11:57:19 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, george.cherian@ti.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: phy: rename nop_usb_xceiv => usb_phy_gen_xceiv
References: <1374869757-923-1-git-send-email-bigeasy@linutronix.de> <1374869757-923-2-git-send-email-bigeasy@linutronix.de> <20130729122022.GF24801@radagast> <20130730070814.GF7656@atomide.com> <51F76C90.90207@linutronix.de> <20130730075650.GI7656@atomide.com>
In-Reply-To: <20130730075650.GI7656@atomide.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 09:56 AM, Tony Lindgren wrote:
> A separate minimal branch against -rc3 sounds good to me.

Great. Felipe, can you please put this change in a separate -rc3 based
branch which you and Tony will pull in?

> Regards,
> 
> Tony
> 

Sebastian
