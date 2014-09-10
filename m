Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaIJTaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:30:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:35366 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaIJTaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:30:21 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org
Subject: [PATCH 00/16 v9] omap 8250 based uart + DMA
Date: Wed, 10 Sep 2014 21:29:55 +0200
Message-Id: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the diff of v8…v9 is small:
- rebased on top's of Greg's tty-next branch
- fixed #10 where we might have THRE interrupt enabled for longer than
  needed
- re-did register setup in #10. Before this "less file" could freeze the
  am335x-evm.

Sebastian

