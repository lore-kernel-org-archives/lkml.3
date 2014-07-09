Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaGIPIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:08:34 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:36016 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbaGIPIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:08:25 -0400
MIME-Version: 1.0
In-Reply-To: <53BD54BC.7080608@ti.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<bc183ef08321e2699a0834d545bade9c7f7d7fcc.1404231535.git.viresh.kumar@linaro.org>
	<53BD54BC.7080608@ti.com>
Date: Wed, 9 Jul 2014 20:38:24 +0530
Message-ID: <CAKohpomWizkJh-=S1BXKLLM1u891VCmJASxmoSVF+Qy7VMy8Fg@mail.gmail.com>
Subject: Re: [PATCH 04/14] cpufreq: cpu0: Add Module Author
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Shawn Guo <shawn.guo@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 20:12, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> Not related to this patch but I think its time to change
> the name of this driver. I never liked this 'cpufreq-cpu0.c'
> and already mentioned that during the reviews of this
> driver.
>
> Not sure if there are still sentiments about it but
> considering the additional functionality coming in,
> the name will definitely miss-leading.

Check last patch, its called cpufreq-generic now.
