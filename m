Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab3LQIri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:47:38 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:48959 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3LQIrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:47:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1312111938580.23022@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1312111937570.23022@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1312111938370.23022@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1312111938580.23022@file01.intranet.prod.int.rdu2.redhat.com>
Date: Tue, 17 Dec 2013 14:17:36 +0530
Message-ID: <CAKohpok_+Dxk0G3hutAtejjhNOj5d2uK+58C6TBf-KuU+Xc7eA@mail.gmail.com>
Subject: Re: [PATCH 3/3] powernow-k6: reorder frequencies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 December 2013 06:09, Mikulas Patocka <mpatocka@redhat.com> wrote:
> This patch reorders reported frequencies from the highest to the lowest,
> just like in other frequency drivers.

This isn't required I believe.. cpufreq core doesn't enforce any restrictions
on order of freqs present in table.
