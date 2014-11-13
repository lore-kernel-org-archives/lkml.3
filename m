Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbaKMSeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:34:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:48651 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648AbaKMSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:34:17 -0500
Message-ID: <5464F9A1.9080901@linutronix.de>
Date: Thu, 13 Nov 2014 19:34:09 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
References: <20141104170233.GB24112@csclub.uwaterloo.ca> <5459079D.7080703@linutronix.de> <20141104172117.GC24112@csclub.uwaterloo.ca> <20141104183315.GD24112@csclub.uwaterloo.ca> <20141104210315.GF24112@csclub.uwaterloo.ca> <20141105011506.GG24112@csclub.uwaterloo.ca> <5459DBB7.1090702@linutronix.de> <20141105153307.GN24110@csclub.uwaterloo.ca> <20141105162024.GH24112@csclub.uwaterloo.ca> <545A50BB.2020307@linutronix.de> <20141105194323.GI24112@csclub.uwaterloo.ca>
In-Reply-To: <20141105194323.GI24112@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 08:43 PM, Lennart Sorensen wrote:
> I managed to get something dma related on uart3.  But it isn't happy:
> 
> [   95.577401] DMA misaligned error with device 53
> repeated many times.
> 
> I wonder if the dma support isn't quite working for the omap572x yet in
> this tree (ti's 3.12.y tree), or maybe it is picky and the driver still
> needs a bit of work.

misaligned dma? I haven't seen any alignment requirement for SDMA/EDMA
and I haven't seen this error on beagle board, am335x-evm or dra7-evm.

> I have had no issues on uart7 and 8 without dma.

So basically what you are saying is that DMA (no matter which channel)
gives you this error and without DMA it works fine?

Sebastian
