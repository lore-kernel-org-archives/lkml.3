Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbaGDQ77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:59:59 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:46221 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaGDQ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:59:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140702190944.GA567@drone.musicnaut.iki.fi>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140702160932.GF5541@saruman.home> <20140702190944.GA567@drone.musicnaut.iki.fi>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 4 Jul 2014 17:59:35 +0100
Message-ID: <CAFEAcA-UyLWteuNUO1xa5cGvQQV-fscJtiaC7B6N=cdTam-UQA@mail.gmail.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 July 2014 20:09, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> When ttyS -> ttyO change was done on OMAP, compatibility was not an issue.
> Why should we care about it now?

You should have cared about it back then as well -- it was
really annoying and required everybody running an OMAP
based board to suddenly fix up their userland and command
line configs when they got broken by a kernel upgrade.

thanks
-- PMM
