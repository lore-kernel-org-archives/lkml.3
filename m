Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab3HZFh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 01:37:28 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54047 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab3HZFhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 01:37:25 -0400
MIME-Version: 1.0
In-Reply-To: <1376388505-30233-8-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-8-git-send-email-l.majewski@samsung.com>
Date: Mon, 26 Aug 2013 11:07:25 +0530
Message-ID: <CAKohponJ_7s39Meg4di_BF-KCcby+LAuOtvedHPRzONG=MN-8w@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 August 2013 15:38, Lukasz Majewski <l.majewski@samsung.com> wrote:
> Special driver data flag (CPUFREQ_BOOST_FREQ) has been added to indicate
> frequency, which can be only enabled for BOOST mode.
> This frequency shall be used only for limited time, since it might cause
> target device to overheat.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>
> ---
> Changes for v7:
> - None

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
