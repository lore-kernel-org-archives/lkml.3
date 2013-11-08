Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab3KHTmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:42:15 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52250 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab3KHTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:42:13 -0500
MIME-Version: 1.0
In-Reply-To: <527CC2A5.7080000@linaro.org>
References: <1381960030-1640-1-git-send-email-tim.kryger@linaro.org>
	<1381960030-1640-2-git-send-email-tim.kryger@linaro.org>
	<527CC2A5.7080000@linaro.org>
Date: Fri, 8 Nov 2013 11:42:12 -0800
Message-ID: <CAAYSxhoHYaFzcoxEAJrNb6d8n1aKGDN68K3eekRT22s0h7960w@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 1/6] ARM: dts: Declare clocks as fixed on bcm11351
From: Tim Kryger <tim.kryger@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 2:53 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:

> I was wondering what is the status of this patchset ?
>
> The patchset touches different areas maintained by different people. Through
> what tree do you expect this patchset to be merged ??

Hi Daniel,

I plan to send an updated version soon to address some concerns raised by Mark.

Once all the maintainers are satisfied and provide their acks, I would
like Christian to take the series into his tree.

I expect Christian will have a few other Broadcom DTS file changes in
his tree so sending the series through him should make it easier to
avoid/manage conflicts.

Christian, would that work for you?

Thanks,
Tim Kryger
