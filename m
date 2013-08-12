Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3HLRBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:01:24 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:39524 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab3HLRBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:01:22 -0400
MIME-Version: 1.0
In-Reply-To: <52090E67.1080703@wwwdotorg.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
	<568f3dbd414b050bb2319d960fb5044a5aed8ee3.1375964117.git.viresh.kumar@linaro.org>
	<5203BCDD.40809@wwwdotorg.org>
	<CAKohpomr8kwDitAFD7FKvHo3zNWz8qT5bkd3yOVEnC_k16o=Dw@mail.gmail.com>
	<CAKohpo=Gy7D2LYmdFU1p+eL-nMoPE18YXWvE2M8t-fb-a5HBgg@mail.gmail.com>
	<5205167F.1070906@wwwdotorg.org>
	<CAKohponQDAqHiRD7Aw5Wk6fEE-d8H=Svg0oBRyb9SKGdqYxGhw@mail.gmail.com>
	<52056842.8060109@wwwdotorg.org>
	<CAKohpon=j=NANLQzYuBdoFVLxQzETy5JDu2vORaAgK3NuEpeAg@mail.gmail.com>
	<52090E67.1080703@wwwdotorg.org>
Date: Mon, 12 Aug 2013 22:31:20 +0530
Message-ID: <CAKohpom4WsD_BSSGEbtmGR3JRzPXx9j1exM7CagwOXZ=0GZnGw@mail.gmail.com>
Subject: Re: [PATCH 35/35] cpufreq: tegra: use cpufreq_table_validate_and_show()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linaro-kernel@lists.linaro.org, Stephen Warren <swarren@nvidia.com>,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org, rjw@sisk.pl,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2013 22:03, Stephen Warren <swarren@wwwdotorg.org> wrote:
> It's in defconfig OK; I think the driver simply isn't initializing since
> some of the clocks it requests don't exist. I'll have our clock driver
> author look into it. In the meantime, I assume that your change is
> likely fine.

I wasn't' talking about your driver but cpufreq_stats.. That is disabled
by default with your defconfig.
