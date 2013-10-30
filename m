Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3J3KGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:06:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:59959 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3J3KGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:06:46 -0400
Date: Wed, 30 Oct 2013 11:06:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?GB2312?B?IrPCu6qyxSI=?= <chenhc@lemote.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: Avoid NULL OOPS in irq handling
In-Reply-To: <fd7ba5f27786bbd812c19dcd6c589eb2.squirrel@mail.lemote.com>
Message-ID: <alpine.DEB.2.02.1310301105260.19212@ionos.tec.linutronix.de>
References: <1380334284-12690-1-git-send-email-chenhc@lemote.com>    <alpine.DEB.2.02.1310291402490.8257@ionos.tec.linutronix.de> <fd7ba5f27786bbd812c19dcd6c589eb2.squirrel@mail.lemote.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1858821961-1383127598=:19212"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1858821961-1383127598=:19212
Content-Type: TEXT/PLAIN; charset=gb2312
Content-Transfer-Encoding: 8BIT

On Wed, 30 Oct 2013, "³Â»ª²Å" wrote:

> I use a Loongson-3(MIPS-series CPU) machine, there is a serial port
> integrated in the CPU (but it iss buggy), and it use handle_percpu_irq()
> as the irq handler. Maybe I should move the checking into
> handle_percpu_irq()?

Why is a device interrupt using handle_percpu_irq()?
 
Thanks,

	tglx
--8323329-1858821961-1383127598=:19212--
