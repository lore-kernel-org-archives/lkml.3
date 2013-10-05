Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3JEPiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:38:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56064 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3JEPit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:38:49 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52503284.3090509@roeck-us.net>
Date: Sat, 05 Oct 2013 08:38:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>, wim@iguana.be
CC: linux-arm-kernel@lists.infradead.org, carlo.caione@gmail.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wdt: sunxi: Fix section mismatch
References: <1380982817-10234-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1380982817-10234-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 07:20 AM, Maxime Ripard wrote:
> This driver has a section mismatch, for probe and remove functions,
> leading to the following warning during the compilation.
>
> WARNING: drivers/watchdog/built-in.o(.data+0x24): Section mismatch in
> reference from the variable sunxi_wdt_driver to the function
> .init.text:sunxi_wdt_probe()
> The variable sunxi_wdt_driver references
> the function __init sunxi_wdt_probe()
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>


