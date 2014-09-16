Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaIPKIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:08:00 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:43496 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaIPKH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:07:58 -0400
Message-ID: <1410861633.5342.4.camel@marge.simpson.net>
Subject: Re: [PATCH v5] x86,cpu-hotplug: assign same CPU number to readded
 CPU
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, bp@alien8.de,
        gong.chen@linux.intel.com, tony.luck@intel.com, x86@kernel.org,
        imammedo@redhat.com, huawei.libin@huawei.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, peterz@infradead.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>, Linn Crosetto <linn@hp.com>
Date: Tue, 16 Sep 2014 12:00:33 +0200
In-Reply-To: <54180899.4060408@gmail.com>
References: <53CF2A81.7080505@jp.fujitsu.com>
	 <53D5CF2A.2030007@jp.fujitsu.com> <5407D27D.4020006@jp.fujitsu.com>
	 <54114D83.7070004@jp.fujitsu.com>
	 <1410755159.5165.24.camel@marge.simpson.net>
	 <1410799463.28990.326.camel@misato.fc.hp.com>
	 <1410839798.5149.22.camel@marge.simpson.net> <54180899.4060408@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 17:53 +0800, Wanpeng Li wrote: 
> Hi Mike,
> 
> 于 14-9-16 上午11:56, Mike Galbraith 写道:
> > On Mon, 2014-09-15 at 10:44 -0600, Toshi Kani wrote:
> >> On Mon, 2014-09-15 at 06:25 +0200, Mike Galbraith wrote:
> >>> On Thu, 2014-09-11 at 16:21 +0900, Yasuaki Ishimatsu wrote:
> >>>> There is no response for two months since posting v4.
> >>>> What can I do for pushing the patch to upstream?
> >>> Looks to me like we have two patches floating about for more or less the
> >>> same problem, this one, and...
> >>>
> >>> https://lkml.org/lkml/2014/7/29/159
> >>>
> >>> ..this one, which you reviewed, and HP both reviewed and tested.
> >>>
> >>> We seem to kinda stuck with Boris having said don't diddle the
> >>> cpu_llc_shared_map, but HP/Intel saying that this map diddling fixes
> >>> their explosions.  If your alternative is preferred over diddling
> >>> cpu_llc_shared_map, perhaps HP/Intel can test/confirm that their
> >>> explosions stay gone?
> >> Well, Boris mentioned later in his email:
> >> https://lkml.org/lkml/2014/7/22/201
> >>
> >> And I agree with his assessment that both patches make sense.
> > Nonetheless, this just reeks of "department of redundancy department".
> > I have nothing against doing both really, but it does leave me wondering
> > if we would not then be merging the mask clearing "just because".
> 
> Maybe you miss my reply.
> 
> https://lkml.org/lkml/2014/7/29/40

Yes, I did.  Thanks.

-Mike

