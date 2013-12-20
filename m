Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3LTKp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:45:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:60156 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3LTKpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:45:54 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        =?UTF-8?q?Sami=20Pietik=C3=A4inen?= <Sami.Pietikainen@wapice.com>,
        tglx@linutronix.de
Subject: ARM: AT91: remove unused pit irq hander and allow higher clockrates for TCLIB
Date: Fri, 20 Dec 2013 11:45:39 +0100
Message-Id: <1387536341-7452-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

these two patches have been sitting in the -RT tree for quite some time
now. Many thanks to Sami Pietikäinen who fixed them while they got broken
somewhere between v3.2 and v3.8. I ported them to v3.13-rc4 and compile
tested but I have no HW to do more testing.


Sebastian
