Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3E3SEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:04:48 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41457 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab3E3SEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:04:41 -0400
MIME-Version: 1.0
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
Date: Thu, 30 May 2013 20:04:40 +0200
Message-ID: <CACRpkdbJY1mZWzFUqWmUR_C8wjis0xtXLOGYNZB9ewqBuxcd5A@mail.gmail.com>
Subject: Re: [PATCH 00/11] Convert GPIO Davinci to platform driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilip@ti.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 9:10 AM, Philip Avinash <avinashphilip@ti.com> wrote:

> GPIO Davinci driver converted to platform driver to support DT booting.
> In this patch series
> - Cleaned gpio Davinci driver code with proper commenting style and appropriate
>   variable names.
> - Create platform driver for GPIO Davinci in da8xx and dm* platforms and removed
>   gpio related member updation in davinci_soc_info structure.
> - DT support added for da850 board and tested on da850 EVM.
> - Remove soc_info reference in the gpio davinci driver and start uses
>   gpiolib interface.

I'll go over and review this. I assume this will then go through
some DaVinci tree and up into ARM SoC when/if I ACK it.

Yours,
Linus Walleij
