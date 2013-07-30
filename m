Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3G3UQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:16:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:58489 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab3G3UQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:16:49 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org
Cc: balbi@ti.com, linux-kernel@vger.kernel.org, george.cherian@ti.com
Subject: am335x, multi instance and phy support, v3
Date: Tue, 30 Jul 2013 22:16:36 +0200
Message-Id: <1375215401-19729-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

patch is mostly unchanged. I also added a phy a rename. I belive Tony is okay
with taking this on a -rc4 based branch.
#2 creates exports the common functions su am335x pieces don't polute the file.
#3 is the new phy using the reset module which is similar to what omap does.
#5 has be alted for reset device node.

Sebastian

