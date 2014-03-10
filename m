Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaCJCSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:18:23 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49650 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaCJCSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:18:22 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <531D20EC.50503@roeck-us.net>
Date: Sun, 09 Mar 2014 19:18:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Markus Mayer <markus.mayer@linaro.org>, Wim Van Sebroeck <wim@iguana.be>
CC: Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: bcm281xx: Fix Kconfig dependency
References: <1394017061-5481-1-git-send-email-markus.mayer@linaro.org>
In-Reply-To: <1394017061-5481-1-git-send-email-markus.mayer@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 02:57 AM, Markus Mayer wrote:
> Use more the applicable ARCH_BCM_MOBILE option instead of ARCH_BCM as
> dependency for bcm_kona_wdt.c.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>

Acked-by: Guenter Roeck <linux@roeck-us.net>


