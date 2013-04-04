Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416Ab3DDFTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:19:35 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35582 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763404Ab3DDFTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:19:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130404161806.8f53f96c7197b978bfa1b63e@canb.auug.org.au>
References: <20130404161806.8f53f96c7197b978bfa1b63e@canb.auug.org.au>
Date: Thu, 4 Apr 2013 10:49:32 +0530
Message-ID: <CAKohpome+u870GuA411UFWA_pTdkvbCSADWcHZ1MeD53QJ3zqw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the imx-mxs tree with the pm tree
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Markus Pargmann <mpa@pengutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2013 10:48, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the imx-mxs tree got a conflict in
> arch/arm/mach-imx/cpufreq.c between commits b43a7ffbf33b ("cpufreq:
> Notify all policy->cpus in cpufreq_notify_transition()") and eb2f50ff93f0
> ("cpufreq: drivers: Remove unnecessary assignments of policy-> members")
> from the pm tree and commit 180cb7d6ab8c ("ARM: imx: Remove cpufreq
> driver") from the imx-mxs tree.
>
> The latter removed the file, so I just did that and can carry the fix as
> necessary (no action is required).

Thanks. Looks correct.
