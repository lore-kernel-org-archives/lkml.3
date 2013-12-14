Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3LNI0E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 03:26:04 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49390 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3LNI0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 03:26:02 -0500
MIME-Version: 1.0
In-Reply-To: <1386271244-3927-8-git-send-email-tim.kryger@linaro.org>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
	<1386271244-3927-8-git-send-email-tim.kryger@linaro.org>
Date: Sat, 14 Dec 2013 00:26:00 -0800
Message-ID: <CAEPRUYqg2hzwudwLq+MyBfY119e22HzBe5H+03vGA4VVrL9rYw@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] clocksource: kona: Add basic use of external clock
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 11:20 AM, Tim Kryger <tim.kryger@linaro.org> wrote:
> When an clock is specified in the device tree, enable it and use it to
> determine the external clock frequency.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---

Reviewed-by: Christian Daudt <bcm@fixthebug.org>

Daniel,
 Are you ok with me pulling this patch in with the rest of the
patchset into the bcm tree ?

 Thanks,
   csd
