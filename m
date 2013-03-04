Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3CDBLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:11:22 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42564 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3CDBLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:11:20 -0500
Date: Mon, 4 Mar 2013 09:11:21 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org, swarren@wwwdotorg.org, jslaby@suse.cz,
        alan@linux.intel.com, arnd@arndb.de, paul.gortmaker@windriver.com,
        damm@opensource.se, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]8250_pci: Add additional WCH CH352 device
Message-ID: <20130304011120.GA15022@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, swarren@wwwdotorg.org, jslaby@suse.cz,
	alan@linux.intel.com, arnd@arndb.de, paul.gortmaker@windriver.com,
	damm@opensource.se, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130302094555.GA9572@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302094555.GA9572@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 05:45:55PM +0800, Wang YanQing wrote:
> This patch fix a problem XScale port
> detect code in autoconfig_16550a treat
> 16550A port as XScale port, caused by
> CH352 device use the 6th bit(UART_IER_UUE)
> in IER as a enhance function make this bit
> w/r.
> 
> for the below device:
> "
> 01:08.0 Serial controller: Device 4348:3253 (rev 10) (prog-if 02 [16550])
> 	Subsystem: Device 4348:3253
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin A routed to IRQ 20
> 	Region 0: I/O ports at e010 [size=8]
> 	Region 1: I/O ports at e000 [size=8]
> 	Kernel driver in use: serial
> "
> [Note: I haven't test this patch, because I can't
> access the hardware now, but it should be right]
> 
I have tested it this morning, it works.

Thanks.
