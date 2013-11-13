Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab3KMIEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:04:01 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:56272 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3KMIDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:03:53 -0500
MIME-Version: 1.0
In-Reply-To: <52827B11.5040308@linaro.org>
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com>
	<1383945677-29674-6-git-send-email-soren.brinkmann@xilinx.com>
	<52827B11.5040308@linaro.org>
Date: Wed, 13 Nov 2013 13:33:52 +0530
Message-ID: <CAKohpo=KaM97jJ2MnZxSeBz=Mf9cSmzk_EFQTL=EVPPvSH=Wag@mail.gmail.com>
Subject: Re: [PATCH 5/7] clocksource/cadence_ttc: Overhaul clocksource
 frequency adjustment
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2013 00:31, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> Hmm, it could be interesting if Viresh can give its opinion on this patch
> [cc'ed].

I am not sure if I understood the problem completely, but if this is about
not allowing frequency transitions from cpufreq when we have started to
suspend our system, then you must have a look at this thread:

https://lkml.org/lkml/2013/10/24/369
