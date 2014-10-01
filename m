Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaJAHSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:18:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaJAHSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:18:22 -0400
Date: Wed, 1 Oct 2014 09:18:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-input@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH] HID: cp2112: remove use of gpiochip_remove() retval
In-Reply-To: <1412087049-4368-1-git-send-email-pramod.gurav@smartplayin.com>
Message-ID: <alpine.LNX.2.00.1410010917000.26311@pobox.suse.cz>
References: <1412087049-4368-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Pramod Gurav wrote:

> Get rid of using return value from gpiochip_remove() as it returns
> void.
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: linux-input@vger.kernel.org 
> Cc: linux-gpio@vger.kernel.org
> 
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

I guess this depends on some other patch that hasn't gone to Linus yet, 
right? As Linus' tree currently has this prototype:

	int gpiochip_remove(struct gpio_chip *chip)

-- 
Jiri Kosina
SUSE Labs
