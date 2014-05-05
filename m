Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaEEPvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:51:39 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41538 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbaEEPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:51:24 -0400
Date: Mon, 5 May 2014 08:51:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 0/6] ARM: sunxi: Machine code cleanup
Message-ID: <20140505155113.GB25199@roeck-us.net>
References: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 10:07:58PM -0500, Maxime Ripard wrote:
> Hi,
> 
> This serie moves the restart code out of the mach-sunxi directory to
> either the watchdog driver or to a new driver in drivers/power/reset.
> 
> Since the reset code was pretty much all the code left in the
> mach-sunxi directory for all the SoCs but the A31, the only thing left
> into mach-sunxi are empty machine definition.
> 
Hi Maxime,

what changed in this version of the series compared to the previous
version ? Is it just the different directory for the reset driver ?

Thanks,
Guenter
