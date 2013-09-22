Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3IVBMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:12:39 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:56074 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3IVBMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <1379785342-25107-3-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379785342-25107-1-git-send-email-m.krawczuk@partner.samsung.com>
	<1379785342-25107-3-git-send-email-m.krawczuk@partner.samsung.com>
Date: Sun, 22 Sep 2013 06:42:35 +0530
Message-ID: <CAKohpokEF_+d_G0LX76JK_dNBtYtAKPznWbDcwLen4pgQTOt6w@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] Cpufreq: s5pv210 cpufreq fixes for CCF
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>, Rob Landley <rob@landley.net>,
        ijc+devicetree@hellion.org.uk, Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 September 2013 23:12, Mateusz Krawczuk
<m.krawczuk@partner.samsung.com> wrote:
> Use common clock framework api to get clock.
>
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/cpufreq/s5pv210-cpufreq.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
