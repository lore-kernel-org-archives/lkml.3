Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaFFW2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:28:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38651 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaFFW2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:28:07 -0400
Message-ID: <53924070.3030209@zytor.com>
Date: Fri, 06 Jun 2014 15:28:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Garbage characters on serial console (Linus "next")
References: <CA+8MBb+f+83Kj3JyuxGfX9EYJNNgLnMgQRLKGZ15yzNM=cYrEg@mail.gmail.com>
In-Reply-To: <CA+8MBb+f+83Kj3JyuxGfX9EYJNNgLnMgQRLKGZ15yzNM=cYrEg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 03:07 PM, Tony Luck wrote:
> Pulled from Linus' "next" branch (HEAD =
> 2b03adc1911d1c84cb7fad8b424234f589547cb3)
> and built & booted on ia64.  I see a lot of random characters on the
> serial console. Suspiciously starting right after reporting the serial
> line has been found.
> 
> Here's what the output looks like when I "vi" the saved file:
> 
> io scheduler noop registered^M
> io scheduler deadline registered^M
> io scheduler cfq registered (default)^M
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5^M
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled^M
> 00:02: ttyS0 at I/O 0x3f8 (irq = 44, base_baud = 115200) is a 16550A^M
> <80>^\þÇ^@üþ^\à^\<8c>àüðð^\<80><80>üðøþ<80>à<8e>^@üà^\àðÀ<80>^@<8e>à^@à<80><80>^\^\ÿ^\^@^\þþà^@à^\ðð^\<80><80>üþ<80>ü<80>þðøüà<8e>^\à<80>ð^@ÿ<80>üðà^@à<8e>ð<80><80><80><80>þðþ<80>üþ^\à^\^\<80>þÇü^\øà<8e>^@^\à^\^\^\ð<8e><80>ðà<8e><80>^\^@^@^\^\<8e><8e>^\àþþ^\<8e>^@^\<80>^@þ^\ÿ^\à<80>^@^\^\ø^\^\à^L^@<8e>ð^\<80>^\^\ü^\ø^\ÿ
> 
> Output continues with alternating blocks of legible text and garbage.
> System eventually boots (with a legible "login:" prompt).
> 

Looks like the baud rate changed...

	-hpa


