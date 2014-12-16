Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaLPIAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:00:41 -0500
Received: from sym2.noone.org ([178.63.92.236]:57527 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaLPIAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:00:39 -0500
Date: Tue, 16 Dec 2014 09:00:37 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, lftan.linux@gmail.com,
        linux-serial@vger.kernel.org, nios2-dev@lists.rocketboards.org
Subject: Re: [PATCH] serial: altera-uart: fix NULL device in log message
Message-ID: <20141216080037.GN16916@distanz.ch>
References: <1418714914-2836-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418714914-2836-1-git-send-email-lftan@altera.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-16 at 08:28:34 +0100, Ley Foon Tan <lftan@altera.com> wrote:
> Add device pointer to port->dev.
> 
> Before:
> 
> "(NULL device *): ttyAL0 at MMIO 0x2020 (irq = 6, base_baud = 3125000)
> is a Altera UART"
> 
> After:
> "altera_uart 2020.serial: ttyAL0 at MMIO 0x2020 (irq = 6, base_baud = 3125000)
> is a Altera UART"
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

Acked-by: Tobias Klauser <tklauser@distanz.ch>
