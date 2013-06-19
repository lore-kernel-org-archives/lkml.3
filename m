Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831Ab3FSPIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:08:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853Ab3FSPIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:08:49 -0400
Date: Wed, 19 Jun 2013 11:08:24 -0400
From: Dave Jones <davej@redhat.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Simon Horman <horms@verge.net.au>, rjw@sisk.pl,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Subject: Re: [PATCH 05/13] cpufreq: e_powersave: call CPUFREQ_POSTCHANGE
 notfier in error cases
Message-ID: <20130619150824.GA1664@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Simon Horman <horms@verge.net.au>, rjw@sisk.pl,
	linaro-kernel@lists.linaro.org, patches@linaro.org,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
	Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
	charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
	dave.martin@arm.com
References: <cover.1371630975.git.viresh.kumar@linaro.org>
 <859db6d3cfc0efbd5b96783967c10cfcb8b5a51a.1371630975.git.viresh.kumar@linaro.org>
 <20130619122202.GB32292@verge.net.au>
 <CAKohpomzWEX+VSNHzBAEJ1aFQtiODBTJfr1PSKxqDvXoWTtg3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomzWEX+VSNHzBAEJ1aFQtiODBTJfr1PSKxqDvXoWTtg3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 08:24:41PM +0530, Viresh Kumar wrote:
 > On 19 June 2013 17:52, Simon Horman <horms@verge.net.au> wrote:
 > > I have no objections to this change but at the same time I don't
 > > feel that I know the code well enough to review it.
 > 
 > Probably I made a mistake adding your name. Don't know how I
 > made up my mind that you are the main contributor for this.
 > 
 > Probably Dave is?

e_powersaver ? Rafael.

	Dave
