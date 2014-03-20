Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbaCTAFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 20:05:35 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:51101 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaCTAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 20:05:32 -0400
MIME-Version: 1.0
In-Reply-To: <532A0C2D.9010600@semaphore.gr>
References: <532A0C2D.9010600@semaphore.gr>
Date: Thu, 20 Mar 2014 05:35:31 +0530
Message-ID: <CAKohpomOqfeKsn=q-G9MM0QtokQgo5Dju48kUEs-imExT9CcfQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix checkpatch errors and warnings
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 March 2014 02:59, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Fix 2 checkpatch errors about using assignment in if condition,
> 1 checkpatch error about a required space after comma
> and 3 warnings about line over 80 characters.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
