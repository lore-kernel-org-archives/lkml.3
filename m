Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3KETAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:00:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37594 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3KETAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:00:52 -0500
Message-ID: <52794061.2000300@infradead.org>
Date: Tue, 05 Nov 2013 11:00:49 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 5 (tty/serial/xilinx_uartps)
References: <20131105181617.228320b251ab24cce48d3b1c@canb.auug.org.au>
In-Reply-To: <20131105181617.228320b251ab24cce48d3b1c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/13 23:16, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20131104:


on i386:

drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_isr':
drivers/tty/serial/xilinx_uartps.c:247:13: error: 'struct uart_port' has no member named 'sysrq'


-- 
~Randy
