Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3JUE6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 00:58:17 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33363 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3JUE6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 00:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <20131018161510.GA8615@lunn.ch>
References: <b2f8d731c817a5bd72842095d18eab81a63a6de4.1382103344.git.viresh.kumar@linaro.org>
	<20131018161510.GA8615@lunn.ch>
Date: Mon, 21 Oct 2013 10:28:15 +0530
Message-ID: <CAKohpon2b1D+d-wf34dUQ0OxE8+wMP0MyNnYSoDzjjiozpsT-Q@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: create per policy rwsem instead of per CPU cpu_policy_rwsem
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 October 2013 21:45, Andrew Lunn <andrew@lunn.ch> wrote:

> Hi Viresh
>
> I tested on my Marvell Dove, which crashed and burned before with
> cpufreq-bench. This version works fine so far. The benchmark has been
> running for ten minutes, whereas before it was lucky to reach ten
> seconds.
>
> Tested-by: Andrew Lunn <andrew@lunn.ch>

Hi Andrew,

Thanks a lot for reporting and testing this patch :) ..
Hopefully it will not cause any issues ones Rafael applies it for linux-next.
