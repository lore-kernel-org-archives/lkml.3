Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935725Ab3FTDqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:46:06 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60084 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935668Ab3FTDqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:46:03 -0400
MIME-Version: 1.0
In-Reply-To: <2925371.ZJMOdCiC6f@vostro.rjw.lan>
References: <1371114118-19488-1-git-send-email-chenxg@marvell.com>
	<CAFgnuDe1bUub92uE1H9Fc9U7AJCYL=WKdyDe2bg00yEr=kMEbQ@mail.gmail.com>
	<CAKohpo=ADC_MGpXFp-QssYS70PHwBBA6qzrWhYGEqZeeaZHLDQ@mail.gmail.com>
	<2925371.ZJMOdCiC6f@vostro.rjw.lan>
Date: Thu, 20 Jun 2013 09:16:02 +0530
Message-ID: <CAKohpon7PjFpzeEPHdQ4SAGmhJ7T1UqrQB86zq9M7aarvNdx1A@mail.gmail.com>
Subject: Re: [PATCH v5] cpufreq: fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Xiaoguang Chen <chenxg.marvell@gmail.com>,
        Xiaoguang Chen <chenxg@marvell.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 June 2013 04:19, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Well, sentences that don't start from upper-case letters don't look like
> separate sentences

s/sequences/sentences for your initial mail.

I misunderstood it as, you want to name cpu{0|1|2} as CPU{1|2|3}..
Obviously sentences must start with capitals.

> and when I see "cpus" written like this I tend to read
> it as "cups" with a typo.

Hmm..
