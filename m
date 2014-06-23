Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaFWJja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:39:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:5039 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbaFWJj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:39:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,529,1400050800"; 
   d="scan'208";a="551927515"
Date: Mon, 23 Jun 2014 17:39:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jet Chen <jet.chen@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [clockevents] WARNING: CPU: 0 PID: 0 at
 kernel/time/tick-oneshot.c:32 tick_stop_event()
Message-ID: <20140623093925.GA1454@localhost>
References: <53A7E357.5040800@intel.com>
 <CAKohpomtHuXP0Q9QnWvJj1d2O=AewMR+nVNE3N_KFJkMpcCHYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomtHuXP0Q9QnWvJj1d2O=AewMR+nVNE3N_KFJkMpcCHYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Mon, Jun 23, 2014 at 02:02:25PM +0530, Viresh Kumar wrote:
> On 23 June 2014 13:50, Jet Chen <jet.chen@intel.com> wrote:
> > Hi Viresh,
> >
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> >
> > git://git.linaro.org/people/vireshk/linux tick/ONESHOT-STOPPED
> 
> Hi Jet/Fengguang,
> 
> Why did your scripts Cc'd LKML for this report? It never used to
> happen for my trees Atleast.

Yeah our build error reports are mostly private emails. However we do
CC LKML for runtime regressions - because there is no easy way for us
to tell whether the reported regression has reached more people.

> These patches haven't been posted to LKML yet and sending
> reports there for these wouldn't be good for their fate :)

Sorry if it hurts. :)

> Anyway, will look at what broke. Thanks.

Thank you!

Cheers,
Fengguang
