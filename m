Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaLAOKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:10:49 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:53214 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaLAOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:10:47 -0500
Date: Mon, 1 Dec 2014 14:09:14 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        Felipe Balbi <balbi@ti.com>, uwe@kleine-koenig.org
Subject: Re: [PATCH] tty: serial: serial-omap: depend on !8250_omap
Message-ID: <20141201140914.728aaa46@lxorguk.ukuu.org.uk>
In-Reply-To: <20141129173418.GY2817@atomide.com>
References: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
	<20141129094823.GA10840@linutronix.de>
	<20141129173418.GY2817@atomide.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well the nightmare userspace switch from ttyS to ttyO few years ago is
> something we want to avoid.. I think the best solution would be to make
> serial-omap.c transparently provide support for ttyO using the new 8250
> code so both ttyS and ttyO devices would just work. Otherwise it will
> be years of "my serial port stopped working" questions again.

Thata a udev problem not a kernel one surely.

Alan
