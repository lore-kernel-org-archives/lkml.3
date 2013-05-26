Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab3EZC6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 22:58:19 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45059 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab3EZC6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 22:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <519F877F.3050801@wwwdotorg.org>
References: <1369379407-12764-1-git-send-email-acourbot@nvidia.com> <519F877F.3050801@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 26 May 2013 11:57:57 +0900
Message-ID: <CAAVeFuJvDOuFAHz1zDNaUBFccZenaz9djOBWH5v8GSmbNSLzbQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra114: correctly output clk_32k
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 12:30 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/24/2013 01:10 AM, Alexandre Courbot wrote:
>> Tegra has a blink timer register that allows to modulate the
>> clk_32k clock before outputting it. Since clk_32k is presented to the
>> kernel as a fixed clock, make sure this register does not tamper with
>> the clock frequency and that clk_32k is outputted as-is, similarly to
>> what is done on t20 and t30.
>
> drivers/clk changes should go to Mike Turquette now that there aren't
> any inter-dependencies between core Tegra and Tegra clk driver patches.
>
> I CC'd him here, but perhaps he'll want this resent if he doesn't have
> the original email still.

I just resent the patch to make things easier.

Thanks,
Alex.
