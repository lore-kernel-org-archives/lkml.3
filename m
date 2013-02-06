Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3BFBl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:41:28 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44744 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab3BFBlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:41:23 -0500
MIME-Version: 1.0
In-Reply-To: <1360088646-19104-3-git-send-email-dirk.brandewie@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
	<1360088646-19104-3-git-send-email-dirk.brandewie@gmail.com>
Date: Wed, 6 Feb 2013 07:11:22 +0530
X-Google-Sender-Auth: In86uwzEEoIne_lP0w5eSnv30rA
Message-ID: <CAOh2x=nBrjL1EZsR1ajPDjQx0V8L4jzQxvLSzU3TuupuYhSJeA@mail.gmail.com>
Subject: Re: [PATCH 2/7] cpufreq: Retrieve current frequency from scaling
 drivers with internal governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 11:54 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Scaling drivers that implement the cpufreq_driver.setpolicy() versus
> the cpufreq_driver.target() interface do not set policy->cur.

> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> Date: 2013-02-04 18:44:40 -0800
>
> cpufreq: balance out cpufreq_cpu_{get,put} for scaling drivers using setpolicy

> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

Wow!! Something happened here. :)
