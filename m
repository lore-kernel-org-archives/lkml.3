Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793Ab3E2RXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:23:09 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59588 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab3E2RXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:23:04 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] i2c: omap: correct usage of the interrupt enable register
References: <1369812944-685-1-git-send-email-oleksandr.dmytryshyn@ti.com>
	<1369812944-685-2-git-send-email-oleksandr.dmytryshyn@ti.com>
Date: Wed, 29 May 2013 10:22:59 -0700
In-Reply-To: <1369812944-685-2-git-send-email-oleksandr.dmytryshyn@ti.com>
	(Oleksandr Dmytryshyn's message of "Wed, 29 May 2013 10:35:44 +0300")
Message-ID: <878v2x7lak.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com> writes:

> Starting from the OMAP chips with version2 registers scheme there are
> 2 registers (I2C_IRQENABLE_SET and I2C_IRQENABLE_CLR) to manage
> interrupts instead of the older OMAP chips with old scheme which have
> only one register (I2C_IE).  Now we should use I2C_IRQENABLE_SET
> register for enabling interrupts and I2C_IRQENABLE_CLR register for
> disabling interrupts.

Why?  (changelogs should always answer the "why" question)

IOW, what is broken without this change, how does it fail?  And equally
important, how is it currently working?

Kevin


