Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3K0PwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:52:05 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:50387 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab3K0PwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:52:02 -0500
MIME-Version: 1.0
In-Reply-To: <4759452.7dXrrSTGCc@vostro.rjw.lan>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org>
	<2309056.KUZA1Fnj0Y@vostro.rjw.lan>
	<CAKohpokjAuUA-o4cJi=N7mO93kTwrmfVqtL-zOHAs6awKoXn1A@mail.gmail.com>
	<4759452.7dXrrSTGCc@vostro.rjw.lan>
Date: Wed, 27 Nov 2013 21:22:01 +0530
Message-ID: <CAKohpomXk34aaG3bKX9AuOcn7ZEXcKrc858jCUhcB2bavcnarQ@mail.gmail.com>
Subject: Re: [PATCH V2] cpufreq: Make sure CPU is running on a freq from freq-table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Carlos Hernandez <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2013 19:52, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> And here my question was: Is it safe to continue at all in that case?

Hmm.. Honestly speaking I haven't thought about it earlier. And from
the kind of inputs we got from Nishanth its not safe at all and so we
really need a BUG_ON in this case, instead of WARN_ON.

What do you say?
