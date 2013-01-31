Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3AaExk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:53:40 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:52794 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3AaExi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:53:38 -0500
MIME-Version: 1.0
In-Reply-To: <f216e85846c302756d55cb6753863a66697f79a6.1359599087.git.viresh.kumar@linaro.org>
References: <f216e85846c302756d55cb6753863a66697f79a6.1359599087.git.viresh.kumar@linaro.org>
Date: Thu, 31 Jan 2013 10:23:37 +0530
Message-ID: <CAKohpo=eEnK8oJ1KEff=sBvyjZzdqmFKUgXe2+bhWAvyVVmzqg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: exynos: simplify .init() for setting policy->cpus
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 10:22, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> With the recent changes in cpufreq core, we just need to set mask of all
> possible cpus into policy->cpus. Rest would be done by core.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Oops! Sent the wrong patch again. Ignore this mail :)
