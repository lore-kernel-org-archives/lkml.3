Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab3IZGhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:37:43 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:51608 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3IZGhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:37:42 -0400
MIME-Version: 1.0
In-Reply-To: <524368CF.4030803@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<5b758e21eeb97f5f68191819c0820673692b6b75.1379779777.git.viresh.kumar@linaro.org>
	<524368CF.4030803@linaro.org>
Date: Thu, 26 Sep 2013 12:07:41 +0530
Message-ID: <CAKohpom_BTYC4DZLP93VzFqfnCudPb9whugPigh-jO0MpHurtw@mail.gmail.com>
Subject: Re: [PATCH 21/21] cpuidle: change governor from within cpuidle_replace_governor()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 04:20, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> Actually I am wondering if all this stuff is not over-engineered.
>
> There are 2 governors, each of them suits for a specific kernel config,
> periodic tick or tickless system.
>
> menu     => tickless system
> periodic => periodic tick system
>
> IMHO, all the code with rating checking and so do not really makes
> sense. Wouldn't make sense to remove this code ?

I am a newbie here, really can't think of all side effects of this :)
