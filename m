Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3AWX1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:27:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:37429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3AWX1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:27:31 -0500
Message-ID: <51007226.1040604@infradead.org>
Date: Wed, 23 Jan 2013 15:28:38 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 23 (pch_uart.c)
References: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au>
In-Reply-To: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/13 22:43, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130122:
> 


on i386:

  CC [M]  drivers/tty/serial/pch_uart.o
drivers/tty/serial/pch_uart.c: In function 'pch_uart_hal_read':
drivers/tty/serial/pch_uart.c:572:11: error: 'struct uart_port' has no member named 'sysrq'
make[4]: *** [drivers/tty/serial/pch_uart.o] Error 1



when SERIAL_PCH_UART_CONSOLE is not enabled.

-- 
~Randy
