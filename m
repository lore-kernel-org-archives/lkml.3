Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3KOKgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:36:23 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35789 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab3KOKgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:36:11 -0500
MIME-Version: 1.0
In-Reply-To: <1384504535-29987-2-git-send-email-tianyu.lan@intel.com>
References: <1383036537-30362-1-git-send-email-tianyu.lan@intel.com>
	<1384504535-29987-1-git-send-email-tianyu.lan@intel.com>
	<1384504535-29987-2-git-send-email-tianyu.lan@intel.com>
Date: Fri, 15 Nov 2013 16:06:10 +0530
Message-ID: <CAKohpo=Nr7upLoRT5P1wADGtvEgZp_gEpsW8=HrYb=QP31rbBg@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] Cpufreq/gov: use tick_nohz_check() to check idle
 micro accouting support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2013 14:05, Lan Tianyu <tianyu.lan@intel.com> wrote:
> Current, od_init() uses get_cpu_idle_time_us() to check whether
> idle micro accouting is supported. The get_cpu_idle_time_us()
> returns -1 only when tick nohz is disabled. This patch is to use
> tick_nohz_check() directly to check nohz enable status instead of
> get_cpu_idle_time_us(). This can avoid unnecessary getting and
> putting cpu.
>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
