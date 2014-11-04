Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaKDVDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:03:19 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:47526 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaKDVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:03:17 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 4 Nov 2014 16:03:15 -0500
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
Message-ID: <20141104210315.GF24112@csclub.uwaterloo.ca>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
 <1412014009-13315-12-git-send-email-bigeasy@linutronix.de>
 <20141104170233.GB24112@csclub.uwaterloo.ca>
 <5459079D.7080703@linutronix.de>
 <20141104172117.GC24112@csclub.uwaterloo.ca>
 <20141104183315.GD24112@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104183315.GD24112@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 01:33:15PM -0500, Lennart Sorensen wrote:
> Well it doesn't work, because I don't have the dma croassbar patches
> from ti-linux-3.14.y which are required to use the full range of dma
> channels on the dra7.
> 
> I will see how well it works without dma at least.

So it seems to be working on our board so far.  Will stress test it
some more.  No DMA of course for now, but oh well.

-- 
Len Sorensen
