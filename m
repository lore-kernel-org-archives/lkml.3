Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3AVJnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:43:24 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:43951 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752217Ab3AVJnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:43:22 -0500
Date: Tue, 22 Jan 2013 10:43:17 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 3/4] watchdog: add support for ux500_wdt watchdog
Message-ID: <20130122094317.GA10214@spo001.leaseweb.com>
References: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org> <1358509214-22407-4-git-send-email-fabio.baltieri@linaro.org> <20130122032745.GP7409@sortiz-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122032745.GP7409@sortiz-mobl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

> On Fri, Jan 18, 2013 at 12:40:13PM +0100, Fabio Baltieri wrote:
> > This patch adds support for the ux500_wdt watchdog that is found in
> > ST-Ericsson Ux500 platform.  The driver is based on PRCMU APIs.
> > 
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > ---
> >  drivers/watchdog/Kconfig                |  12 +++
> >  drivers/watchdog/Makefile               |   1 +
> >  drivers/watchdog/ux500_wdt.c            | 171 ++++++++++++++++++++++++++++++++
> >  include/linux/platform_data/ux500_wdt.h |  19 ++++
> >  4 files changed, 203 insertions(+)
> >  create mode 100644 drivers/watchdog/ux500_wdt.c
> >  create mode 100644 include/linux/platform_data/ux500_wdt.h
> There is a dependency between this one an the first patch.
> Wim, would you like me to carry this patch through the MFD tree ?

Seen the dependancy's -> best way would be to take this via the MFD tree.
I allready looked at the patches and it looks OK at the first glans.
I'll review them and lett you know if they have my Acked-by :-).

Kind regards,
Wim.

