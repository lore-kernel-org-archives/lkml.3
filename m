Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3CUNZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:25:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3CUNZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:25:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 00/11] sp804 and integrator timer CLKSRC_OF support
Date: Thu, 21 Mar 2013 13:24:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@linaro.org,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303211324.37654.arnd@arndb.de>
X-Provags-ID: V02:K0:o2y9W8ykCgcLHRkdAzLWJ2f1hsQ4tMZnKUWvkgI3DMe
 JFxpq41G/w27NffhjzaVzVc/vLNjm1wwJOSSYh/EtLNsN6urnn
 ggHb2qCHyzDqAGlbQ3rKd6HD7XoFMDipusAaQsJ/7myi/SsLV0
 V20UZjioawcgwPLDM6mMiIflmCKD0Qw1eD9fcW7rhhzLvfwpda
 CmZIWKcD1VMMzxVwYzrzu4FZnzwjrlFFYuE2n8/hvRSZDteJKe
 bioKcvsdcX4JaXWQ+eAlW9L8jRO7N3cI5TpSsYfVAXUlAL1vsQ
 C77ZAbFkHYJGHMZMYri5u/Z0EPts25LJlVz0cs6SrtdFQlADVk
 1LhbkYOaOg1V932kAId4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 March 2013, Rob Herring wrote:
> This series is dependent on my CLKSRC_OF clean-up in arm-soc, my
> sched_clock selection series[1], and Arnd's default machine descriptor
> patch (for default clocksource_of_init call). The full series is
> available here:

All your patches look good to me, but I'd suggest you don't depend on
my default machine descriptor patch yet, that just makes the dependencies
harder to track, and we can easily remove all the calls once they
are obsoletely.

	Arnd
