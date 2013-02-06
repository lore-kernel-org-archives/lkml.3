Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3BFCrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:47:48 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50995 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3BFCrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:47:46 -0500
MIME-Version: 1.0
In-Reply-To: <1360116290-23849-2-git-send-email-nzimmer@sgi.com>
References: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com>
	<1360116290-23849-1-git-send-email-nzimmer@sgi.com>
	<1360116290-23849-2-git-send-email-nzimmer@sgi.com>
Date: Wed, 6 Feb 2013 08:17:45 +0530
Message-ID: <CAKohpokQwpRqy2h5EwMjP3qxXgS9pqLL1=445J-pkMXgtA6vUA@mail.gmail.com>
Subject: Re: [PATCH v2 linux-next 1/2] cpufreq: Convert the
 cpufreq_driver_lock to a rwlock
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 February 2013 07:34, Nathan Zimmer <nzimmer@sgi.com> wrote:
> This eliminates the contention I am seeing in __cpufreq_cpu_get.
> It also nicely stages the lock to be replaced by the rcu.
>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> ---
>  drivers/cpufreq/cpufreq.c | 42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
