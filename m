Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbaDWP7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:59:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:50188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbaDWP7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:59:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, wim@iguana.be,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/5] power: reset: Add Allwinner A31 reset code
Date: Wed, 23 Apr 2014 17:58:20 +0200
Message-ID: <8237209.ZduvMhRroZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398265476-29373-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com> <1398265476-29373-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dItBJTiu3zGEULhEuCctKOJ28Fbwydc3+ZWEjgPnbma
 skvQeWA6bsU6i651LbN0nF0CkNZHFBNTXaArFROvYCfuk3B5He
 iS2QDyla2nRGJQgQzFlc9doezadFmXPlHJ8lxXI+isII447UY7
 Rm+1y7cK4xYkrkyuvs74K7TLjTcpB8DYdR3gctaL6G8LlJoOYl
 xRieZjSC/ZrOsKgY4v/bvtBKqKPtw9PRUReXvOOEvG6PLo/DJ/
 v6ZDZldZn+Sb/nJRERZfI3JYOLsA8I8HogdAQ0Rb03uYOgM2ZL
 lQBmkm4teAccS87NwLRi5EHtJ1O9JILAKHWbgtRX7fUJ4iJLsi
 LkaAUDSCRmVuVK6zfnFs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014 17:04:33 Maxime Ripard wrote:
> That code used to be in the machine code, but it's more fit here with other
> restart hooks.
> 
> That will allow to cleanup the machine directory, while waiting for a proper
> watchdog driver for the A31.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
