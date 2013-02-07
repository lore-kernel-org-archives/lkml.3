Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422741Ab3BGWVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:21:25 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:34169 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757861Ab3BGWVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:21:24 -0500
Date: Thu, 7 Feb 2013 23:21:22 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: Convert BookE watchdog driver to watchdog infrastructure
Message-ID: <20130207222122.GB28012@spo001.leaseweb.com>
References: <1360095263-2550-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360095263-2550-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/watchdog/Kconfig     |    1 +
>  drivers/watchdog/booke_wdt.c |  185 +++++++++++++++---------------------------
>  2 files changed, 66 insertions(+), 120 deletions(-)
> 

Added to linux-watchdog-next.

Kind regards,
Wim.

