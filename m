Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3JGNkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 09:40:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:35765 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3JGNkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 09:40:35 -0400
Message-ID: <5252B9C7.5040109@linutronix.de>
Date: Mon, 07 Oct 2013 15:40:23 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: bcousson@baylibre.com, pavel@ucw.cz, aaro.koskinen@iki.fi,
        marek@goldelico.com, balbi@ti.com, tony@atomide.com, kishon@ti.com,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: dts: omap3:  Adapt USB OTG to generic PHY framework
References: <1381152493-28055-1-git-send-email-rogerq@ti.com> <1381152493-28055-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1381152493-28055-2-git-send-email-rogerq@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 03:28 PM, Roger Quadros wrote:
> The generic PHY framewrok expects different properties than the
> old USB PHY framework. Supply those properties.
> 
> Fixes USB OTG port on GAT04 and N900 after the Generic PHY framework was
> merged in greg/usb-next. [1]

Would it be much pain (and do we want this at all) to add a fallback
into the kernel or at least a printk pointing out to update the .dts
for two releases or so? So the user does not need to spent hours to
figure out why it suddenly stopped working.

Sebastian
