Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936242Ab3DIOMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:12:55 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48508 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab3DIOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:12:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130409125509.GH15412@verge.net.au>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
	<3167220d1e262ff22078993a5beec55e82dfd951.1365079581.git.viresh.kumar@linaro.org>
	<20130409125509.GH15412@verge.net.au>
Date: Tue, 9 Apr 2013 19:42:51 +0530
Message-ID: <CAKohpomqfVqiw1PJxBRRA8=A6hV_63AW4nRpM8TfZPA5bypcKQ@mail.gmail.com>
Subject: Re: [PATCH 14/18] cpufreq: sh: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Simon Horman <horms@verge.net.au>
Cc: rjw@sisk.pl, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2013 18:25, Simon Horman <horms@verge.net.au> wrote:
> On Thu, Apr 04, 2013 at 06:24:22PM +0530, Viresh Kumar wrote:
>> This patch moves cpufreq driver of SUPERH architecture to drivers/cpufreq.
>
> Why?
>
> I am missing the cover email where I assume the explanation lies.

Hi Simon,

The idea was to keep all cpufreq drivers at a common and most suitable
place, so that future consolidation work can be done easily and efficiently.

So, functionally this patch shouldn't change anything.
