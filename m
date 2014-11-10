Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaKJFJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:09:27 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62445 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaKJFJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:09:26 -0500
MIME-Version: 1.0
In-Reply-To: <544F0C8C.3090003@nvidia.com>
References: <1412232900-11238-1-git-send-email-vinceh@nvidia.com>
	<CAKohpon=dwc--SSbwjREdrALfXH=7QCw8UJnyVX5x3TCKB=7Bw@mail.gmail.com>
	<54321F90.2010103@nvidia.com>
	<544F0C8C.3090003@nvidia.com>
Date: Mon, 10 Nov 2014 10:39:25 +0530
Message-ID: <CAKohpo=jZAmqvdYr+0uUY8xBi5bK0isADS4o5xsaK+rxALcVHQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: respect the min/max settings from user space
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vince Hsu <vinceh@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>, Dylan Reid <dgreid@google.com>,
        olofj@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 October 2014 08:55, Vince Hsu <vinceh@nvidia.com> wrote:
> Hi Viresh,
>
> Could you remind me where can I find this patch upstream? It seems this was
> missed?

Rafael hasn't picked it up. You can normally look at the tree Rafael
manages:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git

Can you please resend it to Rafael ?
