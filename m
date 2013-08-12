Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3HLGIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:08:18 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:49231 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3HLGIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:08:15 -0400
MIME-Version: 1.0
In-Reply-To: <d518dd39781933a497d44253205b0c039965c718.1376116345.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
	<d518dd39781933a497d44253205b0c039965c718.1376116345.git.viresh.kumar@linaro.org>
Date: Mon, 12 Aug 2013 11:38:14 +0530
Message-ID: <CAKohpon5A-h5p7LNjv11QbiguauWMLgK1SK51L3HkSxh1myvoQ@mail.gmail.com>
Subject: Re: [PATCH 43/44] cpufreq: unicore2: Use generic cpufreq routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 August 2013 12:14, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
> and .attr. So its better if we have generic routines for them which can be used
> by cpufreq drivers then.
>
> This patch uses these generic routines for this driver.
>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/unicore2-cpufreq.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)

My patch was wrong.. It was based on the assumption that everybody who
had implemented a .target() also implements a frequency table and exposes
it.. And the generic routines I have exposed depend on that frequency table.
And this cpufreq driver doesn't expose that freq table...

And so this patch is dropped :(
