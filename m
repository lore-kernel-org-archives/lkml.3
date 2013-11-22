Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3KVKI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:08:56 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:44354 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3KVKIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:08:53 -0500
MIME-Version: 1.0
In-Reply-To: <1385057731-4348-2-git-send-email-prabhakar.csengg@gmail.com>
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com>
	<1385057731-4348-2-git-send-email-prabhakar.csengg@gmail.com>
Date: Fri, 22 Nov 2013 12:08:51 +0200
Message-ID: <CAArO44vmfkroE9w4KviOhjkPvg9bTX9pAtr3oxYjD9u_wVZXeg@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] gpio: davinci: use readl/writel instead of __raw_*
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2013 20:15, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch replaces the __raw_readl/writel with
> readl and writel, Altough the code runs on ARMv5
> based SOCs, changing this will help copying the code
> for other uses.

This replacement has a functional impact: it adds memory barriers.
Please note this in the description.
Also please add a bit of explanation on why do you need to add barriers.

-- 
Regards,
Taras Kondratiuk
