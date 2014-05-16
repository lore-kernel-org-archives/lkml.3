Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbaEPKKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:10:45 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:42485 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbaEPKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAJuA9aitMu_=OLT+=6pX=us03HVfrPZ1zCYFXfNg58W+-nzm3g@mail.gmail.com>
References: <cover.1400230695.git.viresh.kumar@linaro.org>
	<CAJuA9aitMu_=OLT+=6pX=us03HVfrPZ1zCYFXfNg58W+-nzm3g@mail.gmail.com>
Date: Fri, 16 May 2014 15:40:43 +0530
Message-ID: <CAKohpokUP6rnV=UyES1GY0yqwiUndBrJFtw7fwJScsRigbE7tA@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] cpufreq: add support for intermediate (stable)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Abraham <ta.omasab@gmail.com>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arvind Chauhan <arvind.chauhan@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 15:39, Thomas Abraham <ta.omasab@gmail.com> wrote:
> In the given example above, the reworked implementation of cpufreq for
> exynos maintains the transition frequency at 800MHz / 4 = 200MHz by
> using a clock divider. So the transition frequency is ensured to be
> less than or equal to the pre-transition cpu clock frequency.

Thanks for the information. But I think this patchset is still required for
many platforms. Anyway these extra notifications must be sent for exynos
as well.
