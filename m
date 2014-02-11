Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903AbaBKGRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:17:18 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56844 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaBKGRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:17:17 -0500
MIME-Version: 1.0
In-Reply-To: <1392084929-14116-1-git-send-email-t.dakhran@samsung.com>
References: <1392084929-14116-1-git-send-email-t.dakhran@samsung.com>
Date: Tue, 11 Feb 2014 11:47:15 +0530
Message-ID: <CAK9yfHzoBCBpUqhmOMvXmkR510EViBcciveD0rRNtiHxMRC9TQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/1] Boot all secondary cores on Exynos SoC's
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tarek Dakhran <t.dakhran@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tarek Dakhran <t.dakhran@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarek,

On 11 February 2014 07:45, Tarek Dakhran <t.dakhran@samsung.com> wrote:
> Due to implementation of exynos_boot_secondary function
> only one secondary core boots on Exynos SoC's.

Even without this patch I could boot the secondary CPUs on Exynos4210, 4412 and
5250 based boards with the latest Linux kernel (v3.14-rc2+). Is this
patch required for
a specific use case or am I missing something?

---
With warm regards,
Sachin
