Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100Ab3DCGn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:43:58 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56733 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761659Ab3DCGn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <ore61p9gvaic2j0fc083dpbd.1364970699079@email.android.com>
References: <ore61p9gvaic2j0fc083dpbd.1364970699079@email.android.com>
Date: Wed, 3 Apr 2013 12:13:56 +0530
Message-ID: <CAKohponUuwiQ9EiKq66Mgf7zZxonxHs=DNbhx=uydDVB5bed6w@mail.gmail.com>
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: stratosk <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2013 12:01, stratosk <stratosk@semaphore.gr> wrote:
> I'm sorry, I don't understand.
> The goal of this patch is not energy saving.

He probably misunderstood it...

> The goal is to detect CPU load as soon as possible to increase frequency.
>
> Could you please clarify this?

But he is looking for some numbers to prove your patch. Some numbers
that shows performance is better with your changes...
