Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3G2HDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:03:45 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58590 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3G2HDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130726144612.5939419c@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-2-git-send-email-l.majewski@samsung.com>
	<CAKohpoktwZUvs2ap7wk1tudVsiKjbhFkoM5=+AaFZP=+73fEyg@mail.gmail.com>
	<20130726125827.72f9ef18@amdc308.digital.local>
	<CAKohpokqHsHZP0AkPBbmGP=ekLPQrnLCc5j6BsfM6KY01uzG1w@mail.gmail.com>
	<20130726144612.5939419c@amdc308.digital.local>
Date: Mon, 29 Jul 2013 12:33:43 +0530
Message-ID: <CAKohpomCHufjzatndpB0MEHn_jOREUZ5dcaQa0BegLAwOjP-1w@mail.gmail.com>
Subject: Re: [PATCH v6 1/8] cpufreq: Store cpufreq policies in a list
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
        Kukjin Kim <kgene.kim@samsung.com>, durgadoss.r@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 July 2013 18:16, Lukasz Majewski <l.majewski@samsung.com> wrote:
> So instead of reading policies from per_cpu variables for all online
> cpus, you think of using the list explicitly.
>
> Good idea, but can we first finish the boost patches? Such change can
> be applied on top of boost patch series as well.

Its not a problem where we do it. But making sure that we do it :)
If you need to resend this patchset, then that list can be used at the
place I just highlighted.. Change isn't big and so shouldn't be a problem.

Otherwise it might get missed by both of us.
