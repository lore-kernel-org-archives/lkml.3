Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3CHHME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:12:04 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:64589 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3CHHMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:12:01 -0500
MIME-Version: 1.0
In-Reply-To: <513894E3.1070206@slimlogic.co.uk>
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
	<513894E3.1070206@slimlogic.co.uk>
Date: Fri, 8 Mar 2013 08:12:00 +0100
Message-ID: <CACRpkdYHhh=ANiHvgxXiAQ_4LLiBBe0AfJ-60Wy6aEi7Cv0HOg@mail.gmail.com>
Subject: Re: [PATCH v8 0/12] Palmas Updates
From: Linus Walleij <linus.walleij@linaro.org>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        cooloney@gmail.com, rpurdie@rpsys.net, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 2:23 PM, Ian Lartey <ian@slimlogic.co.uk> wrote:

> This patchset adds to the support for the Palmas iseries of PMIC chips.
>
> Some of the patches have previously been submitted individually.
> The DT bindings doc has been added first due to comments that it was
> missing.

Can the patches to the individual subsystems be applied individually
(like can we apply the two GPIO patches to the GPIO tree) or are
the deps such that the whole shebang needs to go in at once and you're
just harvesting ACKs to take it all into MFD or similar?

Yours,
Linus Walleij
