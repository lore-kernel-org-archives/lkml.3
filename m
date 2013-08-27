Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3H0GAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:00:02 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:64433 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3H0F77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 01:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <521BA18D.70706@semaphore.gr>
References: <521BA18D.70706@semaphore.gr>
Date: Tue, 27 Aug 2013 11:29:59 +0530
Message-ID: <CAKohponadgzoHU3bqEJ-Eaun5Azs5o3vH=bOFZRhXy6KZ+uCHw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governor: Fix typos in comments
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 August 2013 00:12, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> - 'Governer' should be 'Governor'
> - 'S' is used for Siemens (electrical conductance) in SI units.
> Use small 's' for seconds.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_governor.c |  2 +-
>  drivers/cpufreq/cpufreq_governor.h | 12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
