Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab3E3S0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:26:50 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58195 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3E3S0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:26:45 -0400
MIME-Version: 1.0
In-Reply-To: <1369206634-6778-12-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
	<1369206634-6778-12-git-send-email-avinashphilip@ti.com>
Date: Thu, 30 May 2013 20:26:44 +0200
Message-ID: <CACRpkdYOGj9SQepDyv3hCSXkQugNb_cwb3+KY0vixEZ7PT-nOg@mail.gmail.com>
Subject: Re: [PATCH 11/11] ARM: davinci: da850 evm: add GPIO DT data
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilip@ti.com>,
        ext Tony Lindgren <tony@atomide.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KV Sujith <sujithkv@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 9:10 AM, Philip Avinash <avinashphilip@ti.com> wrote:

> From: KV Sujith <sujithkv@ti.com>
>
> - Add GPIO DT Data and pinmux for DA850 EVM. GPIO is configurable differently
>   on different boards. So add GPIO pinmuxing in dts file.
> - Dependency: This patch is dependent on Grab-pin-control patch;
>   https://patchwork.kernel.org/patch/2013751/
>
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Looks fine to me, but Tony should review this.

Yours,
Linus Walleij
