Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbaGDNbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:31:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58565 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752613AbaGDNbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:31:22 -0400
Date: Fri, 4 Jul 2014 15:31:16 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: jjhiblot@traphandler.com
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 2/7] pwm: add support for atmel-hlcdc-pwm device
Message-ID: <20140704153116.5fab1e1b@bbrezillon>
In-Reply-To: <539D6328.4020505@traphandler.com>
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
	<1402329860-27520-3-git-send-email-boris.brezillon@free-electrons.com>
	<539D6328.4020505@traphandler.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2014 11:11:04 +0200
Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:


> >  
> > +config PWM_ATMEL_HLCDC_PWM
> > +	tristate "Atmel HLCDC PWM support"
> > +	depends on MFD_ATMEL_HLCDC
> I'd personnaly prefer a 'select' instead of 'depends on' here. Or maybe
> the MFD driver should enabled y defaut for platforms supporting the hlcdc.

After taking a closer look at other drivers, it seems most of sub
drivers "depends on" the MFD driver, so, unless other people complain
about that, I'll keep this definition.

Lee, any opinion on this point ?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
