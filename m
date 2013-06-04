Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab3FDNBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:01:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3FDNBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:01:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, viresh.kumar@linaro.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v1 0/4] dw_dmac: move to own folder and split
Date: Tue, 04 Jun 2013 15:01:36 +0200
Message-ID: <4298714.mlF8oq2qNQ@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370349382-20914-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370349382-20914-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:r01cW2VtCP0HNntXaUn6t40tRqUCsddJp+vRfshLrJL
 srupQf3mKim2JsJ3nKOm4hEdHw+Z9EPR9UOzuGYMfXAYBjy2dq
 VTsZ2u87/M882TpPy1VVMxU5i58paPabQbdDogsYJg6OhrYXEh
 HSttqMOGvmAstgKtGQWUe+mau1YHrn2o1cCxhLpNSBD/DGWJZS
 23tD/pqoy18xnbLm9R7McnzIAJXkHlmdfIeQLaXvsgzUwtZUkc
 8WELVDMe6g9mxYfr01nGlwhbXzuiv7QVhpwjVVYXNOTAAX8sbq
 sps0x8RPH1yuhzF5Q10jJfRmSvPWOKOKu4y78IqQoCpwQzFHUO
 DggZFRyqOOfq77p2fC6Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 15:36:18 Andy Shevchenko wrote:
> This is second attempt to do split as suggested by Arnd et al [1,2].
> There are three most important patches:
>  2/4 moves driver to its own folder
>  3/4 does the actual split
>  4/4 introduces PCI part of the driver
> 
> During this files are renamed: mostly means that dw_dmac prefix is eliminated.
> I hope to get it ready to be included in v3.11.
> 
> [1] http://www.spinics.net/lists/kernel/msg1408174.html
> [2] http://www.spinics.net/lists/kernel/msg1408495.html

Whole series

Acked-by: Arnd Bergmann <arnd@arndb.de>

provided you make it work with !CONFIG_PM.

	Arnd
