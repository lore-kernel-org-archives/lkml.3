Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaGJOzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:55:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:49321 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaGJOzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:55:42 -0400
Message-ID: <53BEA967.4070200@linutronix.de>
Date: Thu, 10 Jul 2014 16:55:35 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: linux-omap@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/6] tty: serial: 8250 core: allow to overwrite & export
 serial8250_startup()
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de> <1404928177-26554-3-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1404928177-26554-3-git-send-email-bigeasy@linutronix.de>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 07:49 PM, Sebastian Andrzej Siewior wrote:
> The OMAP version of the 8250 can actually use 1:1 serial8250_startup().
> However it needs to be extended by a wakeup irq which should to be
> requested & enabled at ->startup() time and disabled at ->shutdown() time.
> 
> v1…v2: add shutdown callback

forgot to copy the callbacks in serial8250_register_8250_port().

Sebastian
