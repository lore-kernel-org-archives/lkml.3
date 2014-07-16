Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbaGPOrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:47:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:56998 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934096AbaGPOpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:45:16 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4] 8250-core based serial driver for OMAP
Date: Wed, 16 Jul 2014 16:44:58 +0200
Message-Id: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I converted most of the omap-serial over to the 8250-core based code where it
once was forked from. I dropped the rs485 support for now.
The runtime-pm does not crash any machines because none of them shutdown the
IP core and/or enter deep idle where it would metter.

Sebastian

