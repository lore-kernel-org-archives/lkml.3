Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaKJLFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:05:23 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:53076 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbaKJLFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:05:21 -0500
Message-ID: <1415617517.4862.44.camel@x220>
Subject: ARM: at91: CONFIG_ARCH_AT91SAM9G45
From: Paul Bolle <pebolle@tiscali.nl>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 12:05:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2014 11:05:18.0665 (UTC) FILETIME=[369F6390:01CFFCD6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your commit 4bf7753b8ab7 ("ARM: at91: remove at91sam9g45/9m10 legacy
board support") landed in today's linux-next (ie, next-20141110). It
removed the Kconfig symbol ARCH_AT91SAM9G45.

There are still two checks for CONFIG_ARCH_AT91SAM9G45 in next-20141110
(one in arch/arm/mach-at91/Makefile.boot and one in
arch/arm/mach-at91/board.h). Are one or more patches to remove these
checks queued somewhere?


Paul Bolle

