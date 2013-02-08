Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946378Ab3BHOg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:36:56 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39334 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760142Ab3BHOgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:36:53 -0500
MIME-Version: 1.0
In-Reply-To: <2130803.VQA31hf2jE@vostro.rjw.lan>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
	<2896238.eRV3G7kyl2@vostro.rjw.lan>
	<CAKohpomrLAQiP58+OVBrm3jb8rd5DK3z+7_kyB_MsKM7UyyWRw@mail.gmail.com>
	<2130803.VQA31hf2jE@vostro.rjw.lan>
Date: Fri, 8 Feb 2013 20:06:52 +0530
Message-ID: <CAKohpokp4YrxKHibewdt+3-WF7P2Fa_bvRidHpjd9SpsT6bPpw@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: valdis.kletnieks@vt.edu, artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 February 2013 18:02, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> So as I said, please rework the fixes on top of linux-pm.git/pm-cpufreq.

I already did. Please check for-rafael branch

> Moreover, I'd very much prefer it if you fixed the problems introduced by
> b8eed8a "cpufreq: Simplify __cpufreq_remove_dev()" separately and *then* any
> other locking problems you're seeing in the code, although people are not
> reporting them.
>
> You seem to have a clear picture of how the code should work now, so that
> won't be a big trouble I guess.

For me all problems are fixed in the current code. :)
