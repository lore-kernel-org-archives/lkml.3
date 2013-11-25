Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3KYEap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 23:30:45 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63139 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3KYEan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 23:30:43 -0500
MIME-Version: 1.0
In-Reply-To: <1385348018-30525-1-git-send-email-tianyu.lan@intel.com>
References: <1385348018-30525-1-git-send-email-tianyu.lan@intel.com>
Date: Mon, 25 Nov 2013 10:00:42 +0530
Message-ID: <CAKohponvz8CjDpMbx=BXpBv5q8d4x94No90sJWjVsTRS_Uj1jw@mail.gmail.com>
Subject: Re: [PATCH] Cpufreq: Change sysfs interface cpuinfo_cur_freq access privilege
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, hg197@gmx.de,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2013 08:23, Lan Tianyu <tianyu.lan@intel.com> wrote:
> Currently, cpuinfo_cur_freq is only accessible for root user while
> other cpufreq sysfs interfaces(E,G scaling_cur_freq) are available
> to ordinary user. This seems make no sense. This patch is to change
> it.

There is nothing wrong with the code and so this is more of a design
change..

Probably Rafael can help us here as cpufreq_cur_freq will read stuff
directly from hardware instead of using cached value in software.

--
viresh
