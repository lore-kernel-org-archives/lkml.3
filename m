Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab3HCLwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 07:52:10 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60102 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3HCLuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 07:50:51 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1375279948.git.viresh.kumar@linaro.org>
References: <cover.1375279948.git.viresh.kumar@linaro.org>
Date: Sat, 3 Aug 2013 17:20:50 +0530
Message-ID: <CAKohpokUNe2Yy7FYUevN3gy0siuibZLk=c8=KYxS4EdVJCheBg@mail.gmail.com>
Subject: Re: [PATCH 00/15] cpufreq: initialize drivers .owner field with THIS_MODULE
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2013 19:49, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> CPUFreq core does following at multiple places:
> module_{get|put}(cpufreq_driver->owner)).
>
> This is done to make sure module doesn't get unloaded if it is currently in use.
> This will work only if the .owner field of cpufreq driver is initialized with a
> valid pointer.
>
> This field wasn't initialized for many cpufreq driver, lets initialize it with
> THIS_MODULE.

You can drop this patchset now as .owner field is removed in the latest
patchset from me which is posted today:

"[PATCH 00/10] CPUFreq: Fixes & Cleanups for 3.12"
