Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968350Ab3DSMPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:15:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968240Ab3DSMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:15:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] ARM64: kernel: compiling issue, duplicate definition of early_console
Date: Fri, 19 Apr 2013 14:15:31 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Christopher Covington <cov@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "anup.patel@linaro.org" <anup.patel@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <5152DB83.8080703@asianux.com> <516E66F9.9070904@asianux.com> <51712213.4060607@asianux.com>
In-Reply-To: <51712213.4060607@asianux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191415.31986.arnd@arndb.de>
X-Provags-ID: V02:K0:ukO5pxvyFik4Qh3zPS0V9MJ5EvX+VV3ms2r/HNSeFmz
 xLQk3uZV7YBssRUg302Xeh9hbAeyKdzCjVWMdg6ZkJU1jeBGg+
 DBrUAm13lCulDpZk81GA4g+pqmLIqEJFt6HTU7FW/tfIW04yi4
 rg/huLUYaJFPd+/hSd1t8ikjNWeS6znQZiBg60o6Et5DmdGgvN
 3Zmr5Wij7xy9FVjRtuP4VmtI3ZCiY5wIFrTvydJKTOUrgY7KFP
 3NFB9m84JyiGyFZMPJT1GSNBFDdh/R3nMqIm5nm6EI/uVtWDeW
 7B40i5Ltw8kxBjPKfXoHtTSyDEMGGATJscDAEHVCKSucbodQSz
 wTUXnygwPU7uswVl/HSg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013, Chen Gang wrote:
>   when compiling with allmodconfig.
>     early_console is already defined as an extern global pointer.
> 
>   need let it point to the object which we intend to (like ARM32 done).
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
