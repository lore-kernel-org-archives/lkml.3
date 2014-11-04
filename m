Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaKDRGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:06:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:33036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaKDRGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:06:42 -0500
Message-ID: <5459079D.7080703@linutronix.de>
Date: Tue, 04 Nov 2014 18:06:37 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 11/13] arm: dts: dra7: add DMA properties for UART
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de> <1412014009-13315-12-git-send-email-bigeasy@linutronix.de> <20141104170233.GB24112@csclub.uwaterloo.ca>
In-Reply-To: <20141104170233.GB24112@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 06:02 PM, Lennart Sorensen wrote:
> 
> According to the manual the DMA channels for UART7 to 10 are:
> 
> uart7:  144 145
> uart8:  146 147
> uart9:  148 149
> uart10: 150 151
> 
> Might as well add those too.  We have uart 7 and 8 in use on our board
> so I am about to go test it.

Mind sharing the manual with me? Mine does not mention DMA channels for
UART7-10. If you are able to test 7+8 (and it works) could you please
make patch which with for the remaining four devices?

Sebastian
