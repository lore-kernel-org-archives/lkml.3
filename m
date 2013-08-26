Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3HZFgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 01:36:35 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:57329 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3HZFge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 01:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <1376388505-30233-6-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-6-git-send-email-l.majewski@samsung.com>
Date: Mon, 26 Aug 2013 11:06:33 +0530
Message-ID: <CAKohpok1efMe180VYjSrSFkSycPr6C61qf7tLZkKY_k07i_KVw@mail.gmail.com>
Subject: Re: [PATCH v7 5/7] cpufreq:exynos:Extend Exynos cpufreq driver to
 support boost framework
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
> The cpufreq_driver's boost_supported flag is true only when boost
> support is explicitly enabled. Boost related attributes are exported only
> under the same condition.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>
> ---
> Changes for v7:
> - Replace CONFIG_CPU_FREQ_BOOST_SW with CONFIG_ARM_EXYNOS_CPU_FREQ_BOOST_SW
> - Move boost_supported initialization to struct cpufreq_driver exynos_driver

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
