Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3HNFXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 01:23:50 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39355 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3HNFXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 01:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <1376377766-2594-2-git-send-email-chenxg@marvell.com>
References: <1376377766-2594-1-git-send-email-chenxg@marvell.com>
	<1376377766-2594-2-git-send-email-chenxg@marvell.com>
Date: Wed, 14 Aug 2013 10:53:48 +0530
Message-ID: <CAKohponW5GwnrL8EktnWb-U5V=eOFQQkbZrx=QgUpfuci3v-0w@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: Only do governor start after successful stop
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg@marvell.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 August 2013 12:39, Xiaoguang Chen <chenxg@marvell.com> wrote:
> cpufreq_add_policy_cpu, __cpufreq_remove_dev and __cpufreq_set_policy
> have operations for governor stop and start.
> Only do the start operation when the previous stop operation succeeds.
>
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> ---
>  drivers/cpufreq/cpufreq.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)

I hope you have seen this patch, which is already in Rafael's tree?

https://lkml.org/lkml/2013/8/6/357
