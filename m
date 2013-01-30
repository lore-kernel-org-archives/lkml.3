Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3A3RMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:12:37 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:57510 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab3A3RMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:12:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130130165321.GD30559@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
	<1359550803-18577-4-git-send-email-fabio.baltieri@linaro.org>
	<CAKohpompi7mzd+XmrUzJ4T=apzpmUcryHaBfQWUoO5G3+4y=_Q@mail.gmail.com>
	<20130130165321.GD30559@balto.lan>
Date: Wed, 30 Jan 2013 22:42:29 +0530
Message-ID: <CAKohpokzBsEQBAPSFTxcC52QmGxst1T-=pzk-E4+dgvyTsiM6g@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] cpufreq: conservative: call dbs_check_cpu only
 when necessary
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 January 2013 22:23, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> On Wed, Jan 30, 2013 at 09:23:22PM +0530, Viresh Kumar wrote:

> Can't argue with this, but the two had some subdle differences (namely
> th two dbs_info structures) and I opted to not mess up forcing some
> non-obvious common code.
>
> Feel free to suggest a strategy.

Just check the patch i mentioned, go ahead with something similar. There
is a lot of code in my original patch which removed redundancy to a big level.
