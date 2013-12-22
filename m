Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab3LVERP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 23:17:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3LVERO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 23:17:14 -0500
Message-ID: <1387685830.5412.37.camel@marge.simpson.net>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
From: Mike Galbraith <bitbucket@online.de>
To: muli.baron@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Sun, 22 Dec 2013 05:17:10 +0100
In-Reply-To: <52B5CE09.5030908@gmail.com>
References: <1383228427.5272.36.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
	 <1383794799.5441.16.camel@marge.simpson.net>
	 <1383798668.5441.25.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
	 <20131220154146.GA18672@breakpoint.cc>
	 <1387617104.30230.7.camel@marge.simpson.net> <52B5CE09.5030908@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:tlj7lnjpGh7cl8RVx37rhzl/gLIn2OzkJ1iBuiOL5u5
 BbidB17ACXSrh4a7mFPjqOdqLMWrR+tuhpdZhher+5VtwPaE2X
 V5rpvnw6jT2tuYM3lXpCeYKMuobSdouvi2xSyhuy5+QtxcuO2Z
 htOEZTmRKqTlEkiJQzBC67d6bVma+3hmgyg8o5rRVI54exeGuK
 HvlIoyWPzwzw2oSfbvYh8571uPz4H2YzFoYadXT8MPazjvndfH
 IXEnIvZ6Ta5yVQ8aUuRNp5JJ19t3YTfjJzfpyDn8CyIGwfd9iF
 nSe62o6Ij2+l1qb/wX+sf45I9VOfkUozSoetNNQkGdPCNxtb4d
 nls5JwbcLJGi0x2xcweGLTovp/YZLFonTj6M/ljnHwlXz7/2ZO
 QA8Cs9oOSAmGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-21 at 19:21 +0200, Muli Baron wrote: 
> On 21/12/2013 11:11, Mike Galbraith wrote:
> >
> > Works, modulo noisy workqueues.
> >
> > rtbox:~ # sleep 35 && killall pert& cgexec -g cpuset:rtcpus taskset -c 3 pert 5
> > [1] 5660
> > 2400.05 MHZ CPU
> > perturbation threshold 0.018 usecs.
> > pert/s:       33 >15.75us:        2 min:  0.04 max: 24.14 avg:  2.51 sum/s:    84us overhead: 0.01%
> > pert/s:       35 >15.54us:        3 min:  0.04 max: 24.89 avg:  2.39 sum/s:    84us overhead: 0.01%
> > pert/s:       30 >15.27us:        2 min:  0.04 max: 23.03 avg:  2.64 sum/s:    80us overhead: 0.01%
> > pert/s:       34 >15.12us:        3 min:  0.04 max: 25.03 avg:  2.51 sum/s:    86us overhead: 0.01%
> > pert/s:       31 >14.93us:        2 min:  0.04 max: 23.86 avg:  2.60 sum/s:    83us overhead: 0.01%
> > Terminated
> >
> 
> I can confirm this works for me as well, but I have noticed some strange behavior under certain 
> conditions.

Hm, so can I.  Same everything, different day, nohz_full is NOT working.

-Mike

