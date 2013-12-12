Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3LLBJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:09:48 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54506 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751226Ab3LLBJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:09:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: Resume regression in 5a87182aa21d6d5d306840feab9321818dd3e2a3
Date: Thu, 12 Dec 2013 02:22:52 +0100
Message-ID: <1905118.1iBkDjFnLH@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131211163812.297d4c81@jbarnes-desktop>
References: <20131211163812.297d4c81@jbarnes-desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 11, 2013 04:38:12 PM Jesse Barnes wrote:
> On one of my BYT systems, I see a hang at resume.  Based on my bisect,
> it looks like this commit is the culprit:
> 
> commit 5a87182aa21d6d5d306840feab9321818dd3e2a3
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Wed Nov 27 09:09:42 2013 +0530
> 
>     cpufreq: suspend governors on system suspend/hibernate
> 
> Is this a known issue?

Yes.

> If so, is there a fix somewhere already?

The commit has been reverted (in the Linus' tree).

Thanks,
Rafael

