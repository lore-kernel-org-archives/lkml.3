Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab3LWI0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:26:07 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58433 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3LWI0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAEPRUYrPXf7QNzput0bz_UPfytRy1eYgyOJYnH5v2v4DCEKSNA@mail.gmail.com>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
	<1386271244-3927-6-git-send-email-tim.kryger@linaro.org>
	<CAEPRUYrPXf7QNzput0bz_UPfytRy1eYgyOJYnH5v2v4DCEKSNA@mail.gmail.com>
Date: Mon, 23 Dec 2013 00:26:01 -0800
Message-ID: <CAEPRUYphct9jJkB7kT=vqmGKX86AQMaZvhxEqChGzizGCS6d1A@mail.gmail.com>
Subject: Re: [PATCH v4 5/8] mmc: sdhci-bcm-kona: Add basic use of clocks
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>, Chris Ball <cjb@laptop.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:14 AM, Christian Daudt <bcm@fixthebug.org> wrote:
> On Thu, Dec 5, 2013 at 11:20 AM, Tim Kryger <tim.kryger@linaro.org> wrote:
>> Enable the external clock needed by the host controller during the
>> probe and disable it during the remove.
>>
>> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
>> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
>
> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
>
> Chris,
>  Are you ok with me pulling this patch along with the rest of the
> patchset into the bcm tree?
>
>  Thanks,
>    csd
Hi Chris,
 I'm hoping to get this patchset and "rename ARCH_BCM to
ARCH_BCM_MOBILE (mmc)" patch into 3.14 still, and these 2 patches are
waiting for your ack and confirmation that you're ok with me pulling
them through armsoc. Can you pls review them ?

 Thanks,
  csd
