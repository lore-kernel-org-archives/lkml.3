Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaLPIAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:00:21 -0500
Received: from sym2.noone.org ([178.63.92.236]:57515 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaLPIAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:00:18 -0500
Date: Tue, 16 Dec 2014 09:00:15 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lftan.linux@gmail.com,
        linux-serial@vger.kernel.org, nios2-dev@lists.rocketboards.org
Subject: Re: [PATCH] serial: altera-juart: fix NULL device in log message
Message-ID: <20141216080015.GM16916@distanz.ch>
References: <1418714866-2744-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418714866-2744-1-git-send-email-lftan@altera.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-16 at 08:27:46 +0100, Ley Foon Tan <lftan@altera.com> wrote:
> Add device pointer to port->dev.
> 
> Before:
> 
> "(NULL device *): ttyJ0 at MMIO 0x1008 (irq = 2, base_baud = 0) is a
> Altera JTAG UART"
> 
> After:
> "altera_jtaguart 1008.serial: ttyJ0 at MMIO 0x1008 (irq = 2, base_baud = 0) is a
> Altera JTAG UART"
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

Acked-by: Tobias Klauser <tklauser@distanz.ch>
