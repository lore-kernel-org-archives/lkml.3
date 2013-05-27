Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3E0QEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:04:21 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52832 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3E0QET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:04:19 -0400
Message-ID: <51A38401.5000103@free-electrons.com>
Date: Mon, 27 May 2013 18:04:17 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
References: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com> <E0B30581-DD0A-46C5-B541-08F389F17018@jcrosoft.com> <51A356A2.4050502@free-electrons.com> <8424D480-48DA-4094-AE68-6A6A66F8FE2B@jcrosoft.com>
In-Reply-To: <8424D480-48DA-4094-AE68-6A6A66F8FE2B@jcrosoft.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/2013 14:59, Jean-Christophe PLAGNIOL-VILLARD wrote:
>
> no will not as you do ifdef CONFIG_PHYLIB and if CONFIG_PHYLIB=m the macro is defended
>
> we do this all the time in the kernel
>
> I add the IS_BUILTIN & co to be used when a simple inline is not sufficient

Ok, it took me a while to understand what you were trying to explain.
I'm sending a patch set now. I don't believe it will be taken in for
3.10 though.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

