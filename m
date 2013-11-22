Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3KVNOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:14:45 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:61531 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab3KVNOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:14:43 -0500
MIME-Version: 1.0
In-Reply-To: <4592811.7DNNYfo4cW@vostro.rjw.lan>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
	<2783049.JzUB2QcsZz@vostro.rjw.lan>
	<CAKohpo=RWi1nRUJq4qx8K+Y7swMDaqwEOH24-KfBCMgdbW=hMQ@mail.gmail.com>
	<4592811.7DNNYfo4cW@vostro.rjw.lan>
Date: Fri, 22 Nov 2013 18:44:42 +0530
Message-ID: <CAKohponYN21_48bQ0zzu5WubRp3zybJyRjeyGOt=vLRAqL_DFw@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] cpufreq: Change freq before suspending governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Stephen Warren <swarren@nvidia.com>, Kukjin Kim <kgene@kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2013 18:55, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> That would be a much more intrusive change.  Definitely not 3.13 material
> at this point.

Agreed..
