Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaEUOwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:52:32 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:52385 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaEUOwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:52:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, santosh.shilimkar@ti.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, w-kwok2@ti.com, rdunlap@infradead.org,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org,
        m-karicheri2@ti.com, olof@lixom.net
Subject: Re: [Patch v4 0/5] Introduce keystone reset driver
Date: Wed, 21 May 2014 16:52:20 +0200
Message-ID: <8843733.6ZFJt7BN6L@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:p5vVUMYswPinj/6H2hReexGcp3UmAoohEJ8whleSOsW
 8JKmZ6/RwmRkpHkWEGo/5ViCrdO5XpPCcn1Dsf7/BfMNkqPa6j
 HninSEfDSDKkovh6YN3iYTZBcZbVgF91YI95vZYC6cteN9UZdM
 F7SMs2Q1jzbuEOXfwOo0gUH5LS/mMrw2BwxuEccAXhKQPwwLc5
 lNbQL9XpFhySe8YF6Jh7exX8orKU5oi0515rVOoWSL9AIjIO9N
 B1BQSpNpM6wP3L92GDuHnJES7pXFBv9hCqXrdt5mnAz+z8VCD7
 Ut++Z7UZrNJ3buJ84AdXUKTYrFwLURDl/MHJXNZwBWoaVPDmcI
 QhaV6oGDtTG5smJ3jHuo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 17:27:29 Ivan Khoronzhuk wrote:
> These patches introduce keystone reset driver.
> 
> The keystone SoC can be rebooted in several ways. By external reset
> pin, by soft and by watchdogs. This driver allows software reset and reset
> by one of the watchdogs. Also added opportunity to set soft/hard reset type.
> 
> Based on linux-next/master

Hi Ivan,

The code looks good to me now, but I have some comments about the
binding. Patches 1, 3 and 5

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the quick update.
