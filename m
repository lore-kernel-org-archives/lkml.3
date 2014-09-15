Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaIOQmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:42:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:35278 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaIOQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:42:11 -0400
Message-ID: <541716DC.9020904@linutronix.de>
Date: Mon, 15 Sep 2014 18:42:04 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Frans Klaver <frans.klaver@xsens.com>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5411967A.6090406@hurleysoftware.com> <54119AAA.9080907@linutronix.de> <20140911151114.GD28458@ci00147.xsens-tech.local> <5411C810.7070906@linutronix.de> <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com> <54129F6C.7040508@linutronix.de> <20140912094010.GE28458@ci00147.xsens-tech.local> <5412C21A.8020203@linutronix.de> <20140912102816.GF28458@ci00147.xsens-tech.local>
In-Reply-To: <20140912102816.GF28458@ci00147.xsens-tech.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 12:28 PM, Frans Klaver wrote:
> port config is 115200 8N1. I don't recall doing anything special. I
> boot, login, less file and get a lock.

So I booted my mini Debian 7.6 (basic system + openssh) on my beagle
bone black which is:

[    0.000000] AM335X ES2.0 (neon )

configured a console, login, invoked "less file". The file was shown, I
hit on the space key so less shows me more of the file. No lock-up.
I tried booting via NFS and MMC. I tried various files with less.

My dot config is here
	https://breakpoint.cc/config-am335x-bb.txt.xz

If there is nothing specific to the file you do less on I have no idea
what else it could if it is not the config.

Sebastian

