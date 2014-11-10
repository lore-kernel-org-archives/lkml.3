Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaKJLKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:10:12 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55662 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbaKJLKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:10:10 -0500
Message-ID: <1415617808.4862.49.camel@x220>
Subject: ARM: at91: CONFIG_ARCH_AT91SAM9RL
From: Paul Bolle <pebolle@tiscali.nl>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 12:10:08 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2014 11:10:08.0302 (UTC) FILETIME=[E3427CE0:01CFFCD6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your commit bcf8c7e7703b ("ARM: at91: remove at91sam9rl legacy board
support") landed in today's linux-next (ie, next-20141110). It removed
the Kconfig symbol ARCH_AT91SAM9RL.

There is still one check for CONFIG_ARCH_AT91SAM9RL in next-20141110 (in
drivers/usb/gadget/udc/atmel_usba_udc.c). Is a patch to remove this
check queued somewhere?


Paul Bolle

