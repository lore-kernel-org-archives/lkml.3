Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab3D3Vik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:38:40 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:63915 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab3D3Vii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:38:38 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V2 2/7] watchdog: bcm63xx_wdt: use devm_ioremap_nocache()
Date: Tue, 30 Apr 2013 23:38:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.7-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>
References: <000f01ce455f$a55a20c0$f00e6240$@samsung.com>
In-Reply-To: <000f01ce455f$a55a20c0$f00e6240$@samsung.com>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304302338.17908.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 avril 2013 07:00:33, Jingoo Han a écrit :
> Use devm_ioremap_nocache() to make cleanup paths simpler.
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Florian Fainelli <florian@openwrt.org>
