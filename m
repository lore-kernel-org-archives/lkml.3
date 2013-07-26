Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab3GZUQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:16:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:38965 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3GZUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:16:07 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        george.cherian@ti.com
Subject: am335x: support for multiple USB instances
Date: Fri, 26 Jul 2013 22:15:53 +0200
Message-Id: <1374869757-923-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The last series has been rebased ontop Felipe's testing branch. It contains
only the support for multiple devices. I decided to keep the temporary change
in the nop (now generic) phy driver which should ease the transition.

I still have the problem that the second USB port does not work after reconnect
due to the missing session bit. I dropped the patch which added it back for now.

Sebastian

