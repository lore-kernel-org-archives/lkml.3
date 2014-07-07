Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaGGNK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:10:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35824 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaGGNKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:10:22 -0400
Date: Mon, 7 Jul 2014 14:09:46 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com
Subject: Re: [RFC PATCH 2/4] tty: serial: 8250 core: allow to overwrite &
 export serial8250_startup()
Message-ID: <20140707140946.6f16f2e4@alan.etchedpixels.co.uk>
In-Reply-To: <1404491651-1388-2-git-send-email-bigeasy@linutronix.de>
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>
	<1404491651-1388-2-git-send-email-bigeasy@linutronix.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jul 2014 18:34:09 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> The OMAP version of the 8250 can actually use 1:1 serial8250_startup().
> However it needs to be extended by a wakeup irq which should to be
> requested & enabled at ->startup() time.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Alan Cox <alan@linux.intel.com>
