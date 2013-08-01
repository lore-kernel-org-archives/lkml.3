Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3HAHiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:38:03 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:61111 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3HAHiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:38:00 -0400
MIME-Version: 1.0
In-Reply-To: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 1 Aug 2013 09:37:39 +0200
Message-ID: <CACQ1gAj_KCJUnBGzv0bnGaUwMgWq-7Noe280YdLGPxK8Ofp3Bw@mail.gmail.com>
Subject: Re: [PATCH 0/8] ARM: at91/dt: make use of periph id macros
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/1 Boris BREZILLON <b.brezillon@overkiz.com>:
> Hello,
>
> This patch series move at91 SoCs peripheral id definitions from machine
> specific include dir to dt-bindings include dir.
> These macros are used to reference interrupts instead of peripheral numbers.
>
> This makes dt definitions cleaner and easier to debug (one can easily tell if
> the peripheral macro used to reference an interrupt line is not the good one).
>
> These macros will be used for clk definitions and references too.
>
> I am not sure 'include/dt-bindings/at91/xxx' is the best place to put these
> definitions as there are no soc specific directories in dt-bindings include
> dir right now. Maybe something like 'include/dt-bindings/soc/at91/xxx' or
> 'include/dt-bindings/peripherals/at91/xxx' would be better.
> What do you think ?
Well, I'd rather use "atmel" than "at91" because, AFAIK, this prefix
has been dropped for new atmel SoCs (sama5 for instance).

my 2 cents...

Richard.
