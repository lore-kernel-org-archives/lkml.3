Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3C0PXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:23:32 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:41451 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3C0PX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:23:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130327152211.GD6347@pengutronix.de>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
	<6c0d4611de3586b12d5df9beaa5d21e4703dd38b.1364205812.git.viresh.kumar@linaro.org>
	<20130327152211.GD6347@pengutronix.de>
Date: Wed, 27 Mar 2013 20:53:28 +0530
Message-ID: <CAKohpokCKczPUWY=o1vf62wyCAGjvVjz0bGW6D3rTm2fnqkZJg@mail.gmail.com>
Subject: Re: [PATCH 4/9] cpufreq: imx: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        linux@arm.linux.org.uk, Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2013 20:52, Markus Pargmann <mpa@pengutronix.de> wrote:
> On Mon, Mar 25, 2013 at 03:41:35PM +0530, Viresh Kumar wrote:
>> This patch moves cpufreq driver of ARM based imx platform to drivers/cpufreq.
>
> I sent a patch that removes imx-cpufreq which was applied by Shawn:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-March/158497.html

I have seen that Markus and i will drop this patch from my list :)
