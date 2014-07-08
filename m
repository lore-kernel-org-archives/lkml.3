Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaGHQrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:47:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:33275 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaGHQrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:47:03 -0400
Message-ID: <53BC2082.9090807@linutronix.de>
Date: Tue, 08 Jul 2014 18:46:58 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de> <20140703184808.GD17769@csclub.uwaterloo.ca> <20140704181317.GE17769@csclub.uwaterloo.ca>
In-Reply-To: <20140704181317.GE17769@csclub.uwaterloo.ca>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 08:13 PM, Lennart Sorensen wrote:
> I get a segfault at this line:
> 
> mvr = uart_read(up, UART_OMAP_MVER);
> 
> I added it to ti's 3.12.y kernel and ran it on uart7 and uart8 on
> a dra7xx-evm as a module (built in the kernel never booted due to
> the crash).

I just managed to boot my dra7-evm on mainline. It crashed in
serial_omap_runtime_resume(). Now that is fixed. The next post should
have this fixed and work (at least on v3.16-rc).

Sebastian
