Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233Ab3FSDQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:16:09 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:58757 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3FSDQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:16:06 -0400
MIME-Version: 1.0
In-Reply-To: <1371606191-5618-1-git-send-email-chenxg@marvell.com>
References: <1371606191-5618-1-git-send-email-chenxg@marvell.com>
Date: Wed, 19 Jun 2013 08:46:06 +0530
Message-ID: <CAKohpont42JcdLH-TawNWVDJeiLNHeAWx4fgvAkyerOD=64MLQ@mail.gmail.com>
Subject: Re: [PATCH v6] Cpufreq: Fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg@marvell.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, njiang1@marvell.com, zjwu@marvell.com,
        ylmao@marvell.com, chenxg.marvell@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 07:13, Xiaoguang Chen <chenxg@marvell.com> wrote:
> There are 4 CPUs and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
> The normal sequence is as below:

I thought Rafael asked to write cpu0 as CPU0, ...
