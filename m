Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaDDOft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:35:49 -0400
Received: from linux-libre.fsfla.org ([208.118.235.54]:55285 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaDDOfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:35:46 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq\@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: loongson2_cpufreq: don't declare local variable as static
Organization: Free thinker, not speaking for the GNU Project
References: <254471b8cee296f860d24368cc467c00b5a07336.1396413826.git.viresh.kumar@linaro.org>
	<or61mqio12.fsf@livre.home>
	<CAKohpo=HfZMmSsHdNyZ5cGhOAyMHkHNH8bBrOwk7kC9eBK_VbQ@mail.gmail.com>
Date: Fri, 04 Apr 2014 11:34:51 -0300
In-Reply-To: <CAKohpo=HfZMmSsHdNyZ5cGhOAyMHkHNH8bBrOwk7kC9eBK_VbQ@mail.gmail.com>
	(Viresh Kumar's message of "Thu, 3 Apr 2014 20:14:24 +0530")
Message-ID: <or1txd88ok.fsf@livre.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr  3, 2014, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> On 3 April 2014 18:10, Alexandre Oliva <oliva@gnu.org> wrote:
>> FWIW, the same mistake is present in at32.

> I will check others as well now :)

Thanks!

>> Reverting all the changes to loongson2_cpufreq.c in 652ed95d5fa makes
>> cpufreq work again, as opposed to printing nan% in all cpufreq stats in
>> cpufreq-info's output, and freezing shortly thereafter.

> You must have a look at this:

> https://lkml.org/lkml/2014/4/2/426 : [PATCH] MIPS/loongson2_cpufreq:
> fix CPU clock rate setting

Thanks, I confirm that patch is enough to avoid the symptoms I'd
described.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer
