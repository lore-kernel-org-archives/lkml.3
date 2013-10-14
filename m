Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3JNQKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:10:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45236 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3JNQKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:10:07 -0400
Date: Mon, 14 Oct 2013 17:10:11 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "pjt@google.com" <pjt@google.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 4/7] sched: power: Remove power capacity hints for
 kworker threads
Message-ID: <20131014161011.GO31039@e103034-lin>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com>
 <20131014133356.GN3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20131014133356.GN3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 Oct 2013 16:10:03.0103 (UTC) FILETIME=[D71136F0:01CEC8F7]
X-MC-Unique: 113101417100500901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 02:33:56PM +0100, Peter Zijlstra wrote:
> On Fri, Oct 11, 2013 at 06:19:14PM +0100, Morten Rasmussen wrote:
> > Removing power hints for kworker threads enables easier use of
> > workqueues in the power driver late callback. That would otherwise
> > lead to an endless loop unless it is prevented in the power driver.
> 
> There's many kworker users; some of them actually consume lots of
> cputime. Therefore how did you come to the conclusion that excepting all
> users was the better choice of a little added complexity in the one
> place where it actually matters?

Agreed that it is not ideal. I will find a better solution for this
problem.

Thanks,
Morten

