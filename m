Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3KURpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:45:11 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:57035 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KURpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:45:08 -0500
MIME-Version: 1.0
In-Reply-To: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com>
Date: Thu, 21 Nov 2013 19:45:06 +0200
Message-ID: <CAArO44tOemuo0PyWMuwwGBb77Lt4_pqbDoKWzROLBi0HGC8F7A@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] Reuse davinci-nand driver for Keystone arch
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2013 13:28, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com> wrote:
> This series contains fixes and updates of Davinci nand driver in
> order to reuse it for Keystone platform.
>
> The series is combination of two following series:
> - Davinci nand driver fixes and updates:
>   https://lkml.org/lkml/2013/11/20/271
> - Reuse davinci-nand driver for Keystone arch
>   https://lkml.org/lkml/2013/11/20/315
>
> Ivan Khoronzhuk (10):
>   mtd: nand: davinci: fix driver registration
>   mtd: nand: davinci: return ENOMEM if memory allocation is failed
>   mtd: nand: davinci: check required ti,davinci-chipselect property
>   mtd: nand: davinci: simplify error handling
>   mtd: nand: davinci: move bindings under mtd
>   mtd: nand: davinci: extend description of bindings
>   mtd: nand: davinci: adjust DT properties to MTD generic
>   mtd: nand: davinci: reuse driver for Keystone arch
>   mtd: nand: davinci: don't set timings if AEMIF is used
>   mtd: nand: davinci: don't request AEMIF address range

For all series:
Reviewed-by: Taras Kondratiuk <taras@ti.com>

-- 
Regards,
Taras Kondratiuk
