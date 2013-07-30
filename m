Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3G3Hfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:35:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:53973 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3G3Hfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:35:50 -0400
Message-ID: <51F76CD3.8080801@linutronix.de>
Date: Tue, 30 Jul 2013 09:35:47 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH v2 1/4] usb: phy: phy-omap-control: Add API to power and
 wakeup
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com> <1374237277-17769-2-git-send-email-george.cherian@ti.com> <20130729142517.GA827@linutronix.de> <51F746BA.9010408@ti.com>
In-Reply-To: <51F746BA.9010408@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 06:53 AM, George Cherian wrote:
> Control module have 2 separate registers for phy on/off per instance
> (offset 0x620 and 0x628), where as
> wkup_ctrl is a shared control module register (offset 0x648). Currently
> the  control module driver maps
>  memory from 0x620 till beyond 0x648 and uses the same mapping for
> writing to wkup_reg.

This I know about. My question is where do you remap this memory. You
have to put the memory address somewhere.

Sebastian
