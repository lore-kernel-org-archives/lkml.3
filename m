Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaBJKGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:06:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:56612 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaBJKGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:06:48 -0500
Date: Mon, 10 Feb 2014 11:06:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: poma <pomidorabelisima@gmail.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, Dave Jones <davej@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: WARNING: CPU: 1 PID: 0 at kernel/time/tick-broadcast.c:668
 tick_broadcast_oneshot_control+0x17d/0x190()
In-Reply-To: <52F84A9B.5020008@gmail.com>
Message-ID: <alpine.DEB.2.02.1402101056260.21991@ionos.tec.linutronix.de>
References: <52F84A9B.5020008@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, poma wrote:

> [   83.558551]  [<ffffffff81025b17>] amd_e400_idle+0x87/0x130

So this seems to happen only on AMD machines which use that e400 idle
mode. I have no idea at the moment whats wrong there. I'll find one of
those machines and try to reproduce.

Thanks,

	tglx




