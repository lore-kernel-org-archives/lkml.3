Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3A3Qxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:53:39 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34146 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab3A3Qxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:53:34 -0500
Date: Wed, 30 Jan 2013 17:53:21 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/4] cpufreq: conservative: call dbs_check_cpu only
 when necessary
Message-ID: <20130130165321.GD30559@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
 <1359550803-18577-4-git-send-email-fabio.baltieri@linaro.org>
 <CAKohpompi7mzd+XmrUzJ4T=apzpmUcryHaBfQWUoO5G3+4y=_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpompi7mzd+XmrUzJ4T=apzpmUcryHaBfQWUoO5G3+4y=_Q@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 09:23:22PM +0530, Viresh Kumar wrote:
> On 30 January 2013 18:30, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > Modify conservative timer to not resample CPU utilization if recently
> > sampled from another SW coordinated core.
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> 
> We are again doing the same mistake which i fixed with:
> 
> commit 4471a34f9a1f2da220272e823bdb8e8fa83a7661
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Fri Oct 26 00:47:42 2012 +0200
> 
>     cpufreq: governors: remove redundant code

Can't argue with this, but the two had some subdle differences (namely
th two dbs_info structures) and I opted to not mess up forcing some
non-obvious common code.

Feel free to suggest a strategy.

Thanks,
Fabio

-- 
Fabio Baltieri
