Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaBPSnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 13:43:46 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:52049 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbaBPSno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 13:43:44 -0500
Message-ID: <1392576223.28866.24.camel@x220>
Subject: Re: [PATCH] arm: imx: remove MACH_MXLADS
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Sun, 16 Feb 2014 19:43:43 +0100
In-Reply-To: <1392574562.956803244@f244.i.mail.ru>
References: <1392573811.28866.22.camel@x220>
	 <1392574562.956803244@f244.i.mail.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Feb 2014 18:43:43.0542 (UTC) FILETIME=[04834D60:01CF2B47]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-16 at 22:16 +0400, Alexander Shiyan wrote:
> Воскресенье, 16 февраля 2014, 19:03 +01:00 от Paul Bolle <pebolle@tiscali.nl>:
> > The Kconfig symbol MACH_MXLADS was added in v2.6.29. It has never been
> > used. Setting it has no effect. There are no calls for
> > machine_is_mxlads(). This symbol can safely be removed.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> This is used by mach-mx1ads.c

How is it used?


Paul Bolle

