Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3IJPb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:31:29 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:42097 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3IJPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:31:08 -0400
MIME-Version: 1.0
In-Reply-To: <1378824287-7696-1-git-send-email-tianyu.lan@intel.com>
References: <1378824287-7696-1-git-send-email-tianyu.lan@intel.com>
Date: Tue, 10 Sep 2013 21:01:07 +0530
Message-ID: <CAKohponpX9AedBrsASojK7fKS-rRN-AQwJT42=mrOJcNpGqE+w@mail.gmail.com>
Subject: Re: [PATCH 1/1] Cpufreq: Remove fossil comment of cpufreq_set_policy
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2013 20:14,  <tianyu.lan@intel.com> wrote:
> From: Lan Tianyu <tianyu.lan@intel.com>
>
> The cpufreq_set_policy() has been removed by commit 632786c. So remove
> related comment.
> ---
>  drivers/cpufreq/cpufreq.c | 4 ----
>  1 file changed, 4 deletions(-)

I have got another patch that takes care of this while fixing other issues..
Yet to be posted though.. but I have queued it up for 3.13..

https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=commit;h=85267596078e3160b3b03de39d95c8e4b5bdf554
