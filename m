Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaE3BTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:19:50 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48791 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaE3BTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:19:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WpYRHaydJnu-+Be9V5ab2qLrA7Wz-9Z_QaG97XJhrhfg@mail.gmail.com>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
	<59e1185a31e61c428aca9f4b8f0a69f182ee458e.1400662383.git.viresh.kumar@linaro.org>
	<CAD=FV=WpYRHaydJnu-+Be9V5ab2qLrA7Wz-9Z_QaG97XJhrhfg@mail.gmail.com>
Date: Fri, 30 May 2014 06:49:48 +0530
Message-ID: <CAKohpomOuB102EDgTLsd0jqA9Fr_cn53LAL8FyAtRErpcsPu6A@mail.gmail.com>
Subject: Re: [PATCH V4 2/3] cpufreq: add support for intermediate (stable) frequencies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2014 01:10, Doug Anderson <dianders@chromium.org> wrote:
> As far as I can tell this notification says "I tried to switch from
> "intermediate_freq" to "policy->restore_freq" but I failed, so I'm
> still at "intermediate_freq".  I think you probably want to pass 0 as
> the last argument to cpufreq_freq_transition_end() to fix...

Correct !!

> Other than that this looks good to me.  I'll do a final review when
> you spin the next version (since I think you need to fix stuff for
> Stephen too).  I'll probably wait and re-review the Tegra version when
> you and Stephen come to a consensus on it.

I am waiting for Stephen's reply on the other thread to close this issue.
