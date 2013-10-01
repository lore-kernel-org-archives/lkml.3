Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3JALOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:14:44 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60383 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3JALOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:14:40 -0400
MIME-Version: 1.0
In-Reply-To: <524A7B00.4010001@collabora.co.uk>
References: <1380069414-2922-1-git-send-email-javier.martinez@collabora.co.uk>
	<87r4cajfx0.fsf@linaro.org>
	<524A7B00.4010001@collabora.co.uk>
Date: Tue, 1 Oct 2013 13:14:38 +0200
Message-ID: <CACRpkdbo=cwp_KzOVYiKayES=jq1_6KGbTRXuEV4w4NOGbFbjA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio/omap: maintain GPIO and IRQ usage separately
From: Linus Walleij <linus.walleij@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kevin Hilman <khilman@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sricharan R <r.sricharan@ti.com>,
        Alexander Holler <holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 9:34 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:

> Linus,
>
> Since this patch-set doesn't cause any regression and fix a long standing issue
> on OMAP, do you think that it would be possible to include on the -rc series as
> a bugfix or do you prefer to wait until 3.13?

I've added it to my fixes branch for v3.12. Since linux-next is not available we
need some extensive build testing first to make sure that if something explodes
it explodes on OMAP only.

So will let this boil a few days and then send a pull request.

Yours,
Linus Walleij
