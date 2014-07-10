Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaGJOyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:54:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40962 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaGJOyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:54:45 -0400
Date: Thu, 10 Jul 2014 15:54:07 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/6] tty: serial: 8250 core: allow to overwrite & export
 serial8250_startup()
Message-ID: <20140710155407.3affb663@alan.etchedpixels.co.uk>
In-Reply-To: <1404928177-26554-3-git-send-email-bigeasy@linutronix.de>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
	<1404928177-26554-3-git-send-email-bigeasy@linutronix.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jul 2014 19:49:33 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> The OMAP version of the 8250 can actually use 1:1 serial8250_startup().
> However it needs to be extended by a wakeup irq which should to be
> requested & enabled at ->startup() time and disabled at ->shutdown() time.
> 
> v1…v2: add shutdown callback
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

1,2 & 4

Acked by: Alan Cox <alan@linux.intel.com>

