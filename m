Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaHZXE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:04:59 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:44098
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbaHZXE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:04:58 -0400
Date: Tue, 26 Aug 2014 18:04:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
In-Reply-To: <20140826213735.GS31659@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1408261803500.15698@gentwo.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org> <20140821222212.GA7996@mtj.dyndns.org> <alpine.DEB.2.11.1408212001100.19762@gentwo.org> <20140822164051.GB15713@mtj.dyndns.org> <alpine.DEB.2.11.1408221241340.23099@gentwo.org>
 <20140823171416.GG13540@mtj.dyndns.org> <alpine.DEB.2.11.1408231500430.31459@gentwo.org> <alpine.DEB.2.11.1408261631350.8819@gentwo.org> <20140826213735.GS31659@mtj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Tejun Heo wrote:

> Ugh.... include hell. :( Does putting the accessors in percpu.h make
> any difference?  Given the tricky nature of cpumask_var_t, I think
> type checking can be pretty useful.

Then its going to be difficult to find. This is related to the
cpumark_var_t handling and should be defined close to where it is
introduced and discussed.

>
> > Regarding naming:
> >
> > this_cpu_ptr_cpumask_var()
> >
> > is ok?
>
> Wouldn't this_cpu_cpumask_var_ptr() be a bit more natural?

Ok.

