Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab3BWD5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 22:57:53 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:35683 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3BWD5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 22:57:50 -0500
MIME-Version: 1.0
In-Reply-To: <1361550275-5716-2-git-send-email-nzimmer@sgi.com>
References: <51265E0F.6090209@sgi.com>
	<1361550275-5716-1-git-send-email-nzimmer@sgi.com>
	<1361550275-5716-2-git-send-email-nzimmer@sgi.com>
Date: Sat, 23 Feb 2013 09:27:50 +0530
Message-ID: <CAKohpo=unSqEUMgqYNS8qmqM3n2qKbx5x0r9_hF9gLrZ58zqqg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] cpufreq: Convert the cpufreq_driver_lock to a rwlock
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 21:54, Nathan Zimmer <nzimmer@sgi.com> wrote:
> This eliminates the contention I am seeing in __cpufreq_cpu_get.
> It also nicely stages the lock to be replaced by the rcu.
>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

@Rafael: I am too bored of seeing this patch again and again :)
Can we get this applied alone for now?
