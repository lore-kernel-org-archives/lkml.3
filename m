Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaKEILp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:11:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:35307 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaKEILk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:11:40 -0500
Message-ID: <5459DBB7.1090702@linutronix.de>
Date: Wed, 05 Nov 2014 09:11:35 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de> <1412014009-13315-12-git-send-email-bigeasy@linutronix.de> <20141104170233.GB24112@csclub.uwaterloo.ca> <5459079D.7080703@linutronix.de> <20141104172117.GC24112@csclub.uwaterloo.ca> <20141104183315.GD24112@csclub.uwaterloo.ca> <20141104210315.GF24112@csclub.uwaterloo.ca> <20141105011506.GG24112@csclub.uwaterloo.ca>
In-Reply-To: <20141105011506.GG24112@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 02:15 AM, Lennart Sorensen wrote:
> Well 4 hours running with multiple reboots (our testsuite reboots every
> 30 minutes to test the watchdog).  So far it has only lost 70 bytes out
> of 40MB of data sent between uart7 and uart8 (and we are pretty sure
> the serial test has a small bug that causes a few bytes to be lost right
> after a reboot sometimes).
> 
> The reason I am even trying the new driver today is that we were seeing
> soft lockups on the CPU whenever the serial ports were being tested,
> usually in less than 5 minutes, so 4 hours without a lockup is a good
> sign.  No idea what might be wrong with the old omap serial driver, but
> it seems something is (unless of course we managed to break it somehow
> when we tried to solve its habit of dropping characters).

Okay. No DMA but the basic part seems to work for you. Thanks for
testing.

Sebastian
