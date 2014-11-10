Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaKJE4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:56:34 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:45540 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaKJE4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:56:32 -0500
MIME-Version: 1.0
In-Reply-To: <c94b68be09dd4bfaa8a80d9877362fb5@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1413515616-15874-1-git-send-email-B29983@freescale.com>
	<CAKohpokotKSvQ13uU4MnCer+qzBUUbGVTd19y7xswCAEKk3nGQ@mail.gmail.com>
	<6aaa50ef5f234fe2896f1c66eb646dfb@DM2PR03MB574.namprd03.prod.outlook.com>
	<CAKohpokSuKOwZ3-OWFtU0z7E1fsMg4tyPiUoFUfw26pD9Py=MA@mail.gmail.com>
	<c94b68be09dd4bfaa8a80d9877362fb5@DM2PR03MB574.namprd03.prod.outlook.com>
Date: Mon, 10 Nov 2014 10:26:32 +0530
Message-ID: <CAKohpokOorF82EDwTyvCcEhpQJvMOXfLzotxj+E9Ys6Jydbk5g@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ platforms
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Yuantian Tang <Yuantian.Tang@freescale.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 October 2014 09:09, Yuantian Tang <Yuantian.Tang@freescale.com> wrote:
> Do we have a conclusion yet?

No. You can keep your initial duplication of Kconfig entries for the time being.
