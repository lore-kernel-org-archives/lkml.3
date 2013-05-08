Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3EHNeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:34:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3EHNeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:34:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bastian Hecht <hechtb@gmail.com>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init unconditionally
Date: Wed, 8 May 2013 15:34:08 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Simon Horman <horms@verge.net.au>, Rob Herring <robherring2@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <201305081416.06611.arnd@arndb.de> <CABYn4sxrcGmnTAJcQR23nMGy8JvqyDrgPOXF4yBFFU_4C8Pc_g@mail.gmail.com>
In-Reply-To: <CABYn4sxrcGmnTAJcQR23nMGy8JvqyDrgPOXF4yBFFU_4C8Pc_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305081534.08336.arnd@arndb.de>
X-Provags-ID: V02:K0:PatPLik2BdxOayYIc4WQ1wDAaU/xDpckK5TDi5okJqF
 ZUnPEUT3NsHT7qUh9ukyx/5YTSfNqfzp1meKLwtC9hfz7jLci+
 Dj1vkDM2lxZHHXTZGZTeO7Xn08b4trHJvYnTx3nZxSrEIo7pT9
 dUIBLm0xPMroZy7IGAxv4mndC0RFY7YQkj2LtTBjiGBN98Z8++
 y/QFhdqpwmvS/+3l1UWpHrkYzWXUyzpCvwvXgwJBSSN3CsxVeB
 Vryt4eClD4vg8YJ7jg/1WdKOXan2ZgZRi5UN3iKSt/wy64RDwd
 tsx1FZbM5EDmg8LuWZ8zOYN2mRPcOhYsi4nQwpvpO+/8TfwFYy
 7rg9H/Nd3BGgxZbJMUas=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 May 2013, Bastian Hecht wrote:
> 
> 2013/5/8 Arnd Bergmann <arnd@arndb.de>:
> 
> I have sent out a patch adding an empty irqchip_init() when
> CONFIG_IRQCHIP is not set with the subject
> [PATCH] irqchip: Add irqchip_init dummy function

Ah, I missed that one. Is it already in linux-next?

	Arnd
