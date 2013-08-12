Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3HLIKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:10:40 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55393 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3HLIKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:10:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130812075841.GG25061@S2101-09.ap.freescale.net>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
	<6d7504823a31aea1e4773998f60720494fb0e6b6.1376116345.git.viresh.kumar@linaro.org>
	<20130812075841.GG25061@S2101-09.ap.freescale.net>
Date: Mon, 12 Aug 2013 13:40:36 +0530
Message-ID: <CAKohponEs-5WEqKTkgyiZP0rfgHzSDy3O9Hyx4U0Xkc-wa-9Mg@mail.gmail.com>
Subject: Re: [PATCH 21/44] cpufreq: imx6q: Use generic cpufreq routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2013 13:28, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Sat, Aug 10, 2013 at 12:14:17PM +0530, Viresh Kumar wrote:
>> Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
>> and .attr. So its better if we have generic routines for them which can be used
>> by cpufreq drivers then.
>>
>> This patch uses these generic routines for this driver.
>>
>> Cc: Shawn Guo <shawn.guo@linaro.org>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Shawn Guo <shawn.guo@linaro.org>

I assume you meant an Ack here :)
