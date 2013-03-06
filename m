Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3CFGs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:48:56 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:56082 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3CFGsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:48:55 -0500
MIME-Version: 1.0
In-Reply-To: <51366C65.7070802@semaphore.gr>
References: <51366C65.7070802@semaphore.gr>
Date: Wed, 6 Mar 2013 14:48:54 +0800
Message-ID: <CAKohpo==-3oqocx-7fbrYx=cFZJ9vgVZ1di3v2T8TZcissbf5w@mail.gmail.com>
Subject: Re: [PATCH 1/3 linux-next] cpufreq: conservative: Fix
 sampling_down_factor functionality
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2013 06:06, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> sampling_down_factor tunable is unused since commit
> 8e677ce83bf41ba9c74e5b6d9ee60b07d4e5ed93 (4 years ago).
>
> This patch restores the original functionality and documents the
> tunable.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  Documentation/cpu-freq/governors.txt   |  6 ++++++
>  drivers/cpufreq/cpufreq_conservative.c | 11 ++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
