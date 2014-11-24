Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaKXLAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:00:43 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:63682 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaKXLAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:00:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141124113854.36975fb2@amdc2363>
References: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
	<1416305790-27746-1-git-send-email-l.majewski@samsung.com>
	<20141121180826.GA3331@developer>
	<20141124113854.36975fb2@amdc2363>
Date: Mon, 24 Nov 2014 16:30:40 +0530
Message-ID: <CAKohpok3pTEk05L7t+o6BYoODnBboAegg1o9dAj8=VOk8G7odQ@mail.gmail.com>
Subject: Re: [PATCH v2] thermal:core:fix: Check return code of the
 ->get_max_state() callback
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 November 2014 at 16:08, Lukasz Majewski <l.majewski@samsung.com> wrote:
> As I look into the cpufreq-dt.c driver - in the cpufreq_init()
> function, the call to of_cpufreq_cooling_register() is performed just
> before cpufreq_table_validate_and_show().
> It looks like a mistake in the cpufreq-dt.c code.

Yes. Just fixed it up and sent a patch. Please provide your
tested-by's..
