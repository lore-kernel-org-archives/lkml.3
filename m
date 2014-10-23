Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaJWKRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:17:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:41458 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaJWKQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:16:58 -0400
Message-ID: <5448D594.4090300@linutronix.de>
Date: Thu, 23 Oct 2014 12:16:52 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Franklin Cooper Jr." <fcooper@ti.com>
Subject: Re: [PATCH V2] tty: serial: omap: Increase max consoles and add check
 to prevent crash
References: <1413908616-843-1-git-send-email-nm@ti.com> <1413982010-11599-1-git-send-email-nm@ti.com>
In-Reply-To: <1413982010-11599-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 02:46 PM, Nishanth Menon wrote:
> Increase the maximum number of consoles possible to 10 since DRA7 now
> has the maximum number of consoles possible. without doing this, for
> example, enabling DRA7 UART10 results in internal data structures and
> console cannot match up and we endup with a crash as follows:

good, Thanks.
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
