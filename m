Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaFMHUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:20:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50947 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaFMHUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:20:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Ptjmr7Gh+zbXMIaPAJX9u
Date: Fri, 13 Jun 2014 00:20:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        kyungmin.park@samsung.com, pekon@ti.com,
        ezequiel.garcia@free-electrons.com, javier@dowhile0.org,
        nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/36] mtd: nand: omap: Move NAND write protect code from
 GPMC to NAND driver
Message-ID: <20140613072023.GK17845@atomide.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
 <1402477001-31132-8-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402477001-31132-8-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140611 01:58]:
> The write protect (WP) pin is only used for NAND devices. So move
> the code into the NAND driver.

Eek, noooo!

Tony
