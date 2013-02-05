Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3BEIMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:12:03 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59099 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3BEIMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:12:01 -0500
MIME-Version: 1.0
In-Reply-To: <1360017913-25667-2-git-send-email-nzimmer@sgi.com>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
	<1360017913-25667-2-git-send-email-nzimmer@sgi.com>
Date: Tue, 5 Feb 2013 13:41:59 +0530
X-Google-Sender-Auth: qWE7YB6kvalbdLENcA9RBy-W65c
Message-ID: <CAOh2x=kwADoQTv4jA9gcrVUyCP5HvA4FyZp7kfpB8nptgs+8UA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Convert the cpufreq_driver_lock to a rwlock
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 4:15 AM, Nathan Zimmer <nzimmer@sgi.com> wrote:
> This completely eliminates the contention I am seeing in __cpufreq_cpu_get.
> It also nicely stages the lock to be replaced by the rcu.
>
> CC: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> ---
>  drivers/cpufreq/cpufreq.c | 44 ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)

You have rebased it against an old version of this file. Please rebase it on
latest Rafael's linux-next branch.

The patch looks good otherwise.
