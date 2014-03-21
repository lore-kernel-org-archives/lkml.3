Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaCUWBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:01:15 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59594 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750849AbaCUWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:01:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        myungjoo.ham@gmail.com
Subject: Re: [PULL REQUEST for Rafael] PM / devfreq: pull request
Date: Fri, 21 Mar 2014 23:16:40 +0100
Message-ID: <6984230.es0GY7P0qj@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1395369289-6416-1-git-send-email-myungjoo.ham@samsung.com>
References: <1395369289-6416-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 21, 2014 11:34:49 AM MyungJoo Ham wrote:
> 
> Dear Rafael,

Hi,
 
> Here goes bugfix devfreq patch.
> 
> Recent patchset of device-tree support / exynos driver updates is omitted in this pull request
> as there could be further updates on the patchset.

OK, pulled, but only because this is a fix.

For new material, please do not send pull requests after -rc6 in the current
cycle.  That is, a pull request with new material for 3.15 should have been
send around 2 weeks ago.


> The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15:
> 
>   Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git for-rafael
> 
> for you to fetch changes up to e35d35a1c0b3a7317d77e03e686a4a205cdd4eed:
> 
>   PM / devfreq: Rewrite devfreq_update_status() to fix multiple bugs (2014-03-21 11:16:30 +0900)
> 
> ----------------------------------------------------------------
> Pull request for Rafael. Bugfix only.
> (recence changes of DT/Exynos drivers need further work)
> 
> ----------------------------------------------------------------
> Saravana Kannan (1):
>       PM / devfreq: Rewrite devfreq_update_status() to fix multiple bugs
> 
>  drivers/devfreq/devfreq.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
