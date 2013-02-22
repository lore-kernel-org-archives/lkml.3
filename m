Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3BVCq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:46:57 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61328 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab3BVCqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:46:55 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1360568193.git.viresh.kumar@linaro.org>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
Date: Fri, 22 Feb 2013 08:16:54 +0530
Message-ID: <CAKohpokNPzTDOxMTbURugW8AX7AwxwgTTVfJkDNripEaSoQ=Sw@mail.gmail.com>
Subject: Re: [PATCH V2 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com,
        Viresh Kumar <viresh.kumar@linaro.org>, Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2013 13:19, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This is targetted for 3.10-rc1 or linux-next just after the merge window.

Hi Rafael,

I have pushed this patch again with the modifications/fixups i posted:
cpufreq-for-3.10

Also i have swapped patch 3 & 4, in case you decide to drop that Kconfig
patch which is no. 4 now :)

--
viresh
