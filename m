Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaGaX7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 19:59:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:26746 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaGaX7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 19:59:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,775,1400050800"; 
   d="scan'208";a="570225963"
Date: Fri, 1 Aug 2014 07:59:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [perf/x86/RAPL] BUG: unable to handle kernel NULL pointer
 dereference at 00000028
Message-ID: <20140731235942.GA5635@localhost>
References: <20140730040008.GF16537@localhost>
 <CABPqkBRcCVjohrYGCo0XuiAAaSGscLnjsgttvGB7EkdxgX1t5w@mail.gmail.com>
 <20140730055333.GA29881@localhost>
 <CABPqkBR-==vga4ZsaiLPB2SAGJvd4=BJ3ArkSuSDYexSQC+w+Q@mail.gmail.com>
 <20140731023233.GA1259@localhost>
 <CABPqkBQ5WagvWLa4ojLAZB2fgBUa53YstBsmLS6JqVzjZ2aEaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ5WagvWLa4ojLAZB2fgBUa53YstBsmLS6JqVzjZ2aEaQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 07:57:25PM +0200, Stephane Eranian wrote:
> On Thu, Jul 31, 2014 at 4:32 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Hi Stephane,
> >
> > On Wed, Jul 30, 2014 at 07:56:11PM +0200, Stephane Eranian wrote:
> >> On Wed, Jul 30, 2014 at 7:53 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >> > On Wed, Jul 30, 2014 at 06:45:58AM +0200, Stephane Eranian wrote:
> >> >> On Wed, Jul 30, 2014 at 6:00 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >> >> > Greetings,
> >> >> >
> >> >> > 0day kernel testing robot got the below dmesg and the first bad commit is
> >> >> >
> >> >> Is this booting a guest kernel or native?
> >> >
> >> > It's a guest kernel.
> >> >
> >> >> What is the  host CPU?
> >> >
> >> > The host CPU is E5-2680, Sandy Bridge-EP.
> >> >
> >> I thought this problem had already be mentioned a while back.
> >>
> >> See https://lkml.org/lkml/2014/3/6/685
> >> And https://lkml.org/lkml/2014/4/23/512
> >>
> >> So what you are telling here is that those two fixes never made it or
> >> that you are
> >> running an older kernel.
> >
> > I just checked linux-next and find that the bug in rapl_pmu_init() has
> > been fixed. linux-next happen to have the same "BUG: unable to handle
> > kernel NULL pointer dereference" message but at another function
> > validate_chain().. Attached is the dmesg in linux-next.
> >
> > Sorry for the noise!
> >
> Is it fixed with the two patches I referred you to?

Yes.

Thanks,
Fengguang

