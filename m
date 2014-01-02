Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaABRk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:40:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbaABRkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:40:55 -0500
Date: Thu, 2 Jan 2014 12:40:52 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] powernow-k6: reorder frequencies
In-Reply-To: <CAKohpok_+Dxk0G3hutAtejjhNOj5d2uK+58C6TBf-KuU+Xc7eA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1401021238460.16351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1312111937570.23022@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1312111938370.23022@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1312111938580.23022@file01.intranet.prod.int.rdu2.redhat.com> <CAKohpok_+Dxk0G3hutAtejjhNOj5d2uK+58C6TBf-KuU+Xc7eA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Dec 2013, Viresh Kumar wrote:

> On 12 December 2013 06:09, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > This patch reorders reported frequencies from the highest to the lowest,
> > just like in other frequency drivers.
> 
> This isn't required I believe.. cpufreq core doesn't enforce any restrictions
> on order of freqs present in table.

But the cpufreq-info tool lists the frequencies misordered.

This is not a serious bug. The patch just makes the output of cpufreq-info 
look better.

Mikulas
