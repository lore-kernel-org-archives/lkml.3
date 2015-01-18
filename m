Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbbARMCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:02:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60674 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbARMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:02:40 -0500
Date: Sun, 18 Jan 2015 13:02:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Subject: Re: [PATCH] bluetooth: Add hci_h4p driver
Message-ID: <20150118120238.GA16357@amd>
References: <20141223130219.GA5731@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223130219.GA5731@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add HCI driver for H4 with Nokia extensions. This device is used on
> Nokia N900 cell phone.
> 
> Older version of this driver lived in staging, before being reverted
> in a4102f90e87cfaa3fdbed6fdf469b23f0eeb4bfd .

Any news here? I'd like the driver to hit 3.20...

								Pavel


>  Kconfig      |   10 
>  Makefile     |    4 
>  nokia_core.c | 1149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  nokia_fw.c   |   99 +++++
>  nokia_h4p.h  |  214 ++++++++++
>  nokia_uart.c |  171 ++++++++
>  7 files changed, 1667 insertions(+)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
