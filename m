Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3ERLpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 07:45:42 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:37406 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3ERLpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 07:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <1368807024-15251-1-git-send-email-dirk.j.brandewie@gmail.com>
References: <1368801497-13072-1-git-send-email-dirk.j.brandewie@gmail.com>
	<1368807024-15251-1-git-send-email-dirk.j.brandewie@gmail.com>
Date: Sat, 18 May 2013 17:15:37 +0530
X-Google-Sender-Auth: rtTWFtQxiDl86rizbadfeikrUh4
Message-ID: <CAOh2x==jU5aFBQqGyARX7A0kNNEqpxCh4xOrqsv10MG4st7LyA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Add additional supported CPU ID
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-pm@vger.kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 9:40 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>
> Add CPU ID for Ivybrigde processor.
>
> Cc: torvalds@linux-foundation.org
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/intel_pstate.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Add my Acked-by: Viresh Kumar <viresh.kumar@linaro.org>, even if
next version is required with some more machine no.s
