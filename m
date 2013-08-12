Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3HLJKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 05:10:23 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:58014 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab3HLJKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:10:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130812110741.608e1e34@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-3-git-send-email-l.majewski@samsung.com>
	<CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com>
	<20130726103321.21238bbb@amdc308.digital.local>
	<CAKohpokK8eNid3yNGTEax_-3CZNaJ4T6Osz8RrXk11hn+Mmxxg@mail.gmail.com>
	<20130812110741.608e1e34@amdc308.digital.local>
Date: Mon, 12 Aug 2013 14:40:19 +0530
Message-ID: <CAKohpok0a26gVomJx4TY7x9nYgqX71Fh2Z7PuKVdj0O_NOi2nw@mail.gmail.com>
Subject: Re: [PATCH v6 2/8] cpufreq: Add boost frequency support in core
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
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2013 14:37, Lukasz Majewski <l.majewski@samsung.com> wrote:
> Do you have any second thoughts about this? Shall I leave it as it is
> now?

Honestly speaking I didn't had a chance to look into this..
Leave it as is, in case there is some problem we can patch it later.
