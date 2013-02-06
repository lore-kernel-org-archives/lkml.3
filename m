Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3BFCxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:53:01 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:46562 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3BFCw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:52:59 -0500
MIME-Version: 1.0
In-Reply-To: <1360116290-23849-3-git-send-email-nzimmer@sgi.com>
References: <74F10842A85F514CA8D8C487E74474BB2D2F925E@P-EXMB1-DC21.corp.sgi.com>
	<1360116290-23849-1-git-send-email-nzimmer@sgi.com>
	<1360116290-23849-3-git-send-email-nzimmer@sgi.com>
Date: Wed, 6 Feb 2013 08:22:57 +0530
Message-ID: <CAKohpo=3qnhtVOniYWPJQLSkAnhMkYj8_yvHR+QE46Pzdi=WhA@mail.gmail.com>
Subject: Re: [PATCH v2 linux-next 2/2] cpufreq: Convert the
 cpufreq_driver_lock to use the rcu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 February 2013 07:34, Nathan Zimmer <nzimmer@sgi.com> wrote:
> In general rwlocks are discourged so we are moving it to use the rcu instead.
>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> ---
>  drivers/cpufreq/cpufreq.c | 173 +++++++++++++++++++++++++---------------------
>  1 file changed, 96 insertions(+), 77 deletions(-)

bleeding-edge got updated again and this patch would have conflicts :)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
