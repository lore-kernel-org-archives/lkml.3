Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946520Ab3BHOpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:45:38 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44498 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab3BHOpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:45:24 -0500
MIME-Version: 1.0
In-Reply-To: <2612804.Hcyse1lRVO@vostro.rjw.lan>
References: <CA+icZUX-hh+RjEOrKABBtecmb4C-5azSmdTx6D7SLuSpcQE+kQ@mail.gmail.com>
	<CAJd=RBDwdO+n3H4M=5W5q75q3yUVL7L2RonWnCE7sfsfW1K5ig@mail.gmail.com>
	<CA+icZUUaFb8zvdkY2JLz5h_7CBgaTzyyTphGid+GkigV+NfVKA@mail.gmail.com>
	<2612804.Hcyse1lRVO@vostro.rjw.lan>
Date: Fri, 8 Feb 2013 20:15:22 +0530
Message-ID: <CAKohpom0yjSyU+OhK4vdi5R=+JsmAEw2nOsvupDOiWMYsdz3Pg@mail.gmail.com>
Subject: Re: [linux-pm] linux-next: Tree for Feb 8 [ smp|cpufreq: WARNING: at
 kernel/smp.c:245 smp_call_function_single ]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sedat.dilek@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Linux ACPI <linux-acpi@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>, linux-next@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 February 2013 18:51, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, February 08, 2013 01:47:44 PM Sedat Dilek wrote:
>> >> [    0.377473]  [<ffffffff8105a5ef>] warn_slowpath_common+0x7f/0xc0
>> >> [    0.377479]  [<ffffffff81579130>] ? acpi_cpufreq_target+0x2c0/0x2c0
>> >> [    0.377483]  [<ffffffff8105a64a>] warn_slowpath_null+0x1a/0x20
>> >> [    0.377487]  [<ffffffff810bb7e6>] smp_call_function_single+0x146/0x190
>> >> [    0.377492]  [<ffffffff81579130>] ? acpi_cpufreq_target+0x2c0/0x2c0
>> >> [    0.377496]  [<ffffffff810bb881>] smp_call_function_any+0x51/0x100
>> >> [    0.377500]  [<ffffffff815788c9>] get_cur_val+0x99/0x130
>> >> [    0.377504]  [<ffffffff81579444>] ? acpi_cpufreq_cpu_init+0x2b4/0x6a0
>> >> [    0.377508]  [<ffffffff81578db0>] get_cur_freq_on_cpu+0x60/0x80
>> >> [    0.377512]  [<ffffffff815795a2>] acpi_cpufreq_cpu_init+0x412/0x6a0
>> >> [    0.377517]  [<ffffffff81575bb9>] cpufreq_add_dev+0x2d9/0x4f0

> This problem was introduced by some cpufreq changes that have been dropped from
> linux-next for now (they are still present in the one you're testing, though).

I know why you got this crash and a pull from following would
certainly fix it :)

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-rafael
