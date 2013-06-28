Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3F1I1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:27:45 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:47043 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3F1I1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:27:42 -0400
MIME-Version: 1.0
In-Reply-To: <1372405697-13556-1-git-send-email-cw00.choi@samsung.com>
References: <1372405697-13556-1-git-send-email-cw00.choi@samsung.com>
Date: Fri, 28 Jun 2013 13:57:41 +0530
Message-ID: <CAKohpomk7tC4xZ32sOh4NQR-qNOM=xHj43GcMu_squ1nFELGpg@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 June 2013 13:18, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>  drivers/cpufreq/Kconfig            |   6 +
>  drivers/cpufreq/cpufreq.c          |   4 +
>  drivers/cpufreq/cpufreq_governor.c |  15 +++
>  drivers/cpufreq/cpufreq_stats.c    | 241 +++++++++++++++++++++++++++++++++----
>  include/linux/cpufreq.h            |   6 +
>  5 files changed, 246 insertions(+), 26 deletions(-)

Please update Documentation/cpu-freq/cpufreq-stats.txt for this as well.
