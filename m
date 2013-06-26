Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3FZLIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:08:18 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38816 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3FZLIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:08:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130626130407.021c05cb@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-2-git-send-email-l.majewski@samsung.com>
	<CAKohpomStuSGyQHnk9jNLpije=SAkb4zHg40zHDgLRCUQeZC1A@mail.gmail.com>
	<20130626125411.5dc935bf@amdc308.digital.local>
	<CAKohpom1yJOAVZ1XE+Q+dtrZM1N6Zqd7DjURSA_f2fhQ1OiCJA@mail.gmail.com>
	<20130626130407.021c05cb@amdc308.digital.local>
Date: Wed, 26 Jun 2013 16:38:15 +0530
Message-ID: <CAKohpo=aaJyhZ1U2W=DUyi8wGH=rLCL47SBSO7TgsxHXamdotA@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] cpufreq: Store cpufreq policies in a list
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, t.figa@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2013 16:34, Lukasz Majewski <l.majewski@samsung.com> wrote:
> err_out_kobj_put:
>         list_del(&cpufreq_policy_list);
>         [rest of error path]

I couldn't find err_out_kobj_put in existing code :)

BTW, just add to the list only once everything passed.
