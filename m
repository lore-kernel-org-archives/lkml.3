Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3CFGtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:49:52 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:45963 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3CFGtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:49:51 -0500
MIME-Version: 1.0
In-Reply-To: <51366C70.3020406@semaphore.gr>
References: <51366C70.3020406@semaphore.gr>
Date: Wed, 6 Mar 2013 14:49:50 +0800
Message-ID: <CAKohpo=aofVQGe3KMOqXpb67i627pH3sgBhFqwgxHR3pP3TBqQ@mail.gmail.com>
Subject: Re: [PATCH 2/3 linux-next] cpufreq: conservative: Fix the logic in
 frequency decrease checking
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2013 06:06, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> When we evaluate the CPU load for frequency decrease we have to compare
> the load against down_threshold. There is no need to subtract 10 points
> from down_threshold.
>
> Instead, we have to use the default down_threshold or user's selection
> unmodified.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_conservative.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
