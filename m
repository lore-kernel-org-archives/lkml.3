Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3KKWnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:43:13 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49275 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3KKWnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:43:07 -0500
Date: Mon, 11 Nov 2013 17:43:04 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Tony Luck <tony.luck@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "l.majewski@samsung.com" <l.majewski@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
In-Reply-To: <52812F6D.8090404@linux.intel.com>
Message-ID: <alpine.LFD.2.10.1311111742040.9667@knanqh.ubzr>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org> <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com> <20131111165453.GB4586@e103034-lin> <20131111183142.GF29572@arm.com> <52812F6D.8090404@linux.intel.com>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013, Arjan van de Ven wrote:

> On 11/11/2013 10:31 AM, Catalin Marinas wrote:
> > I agree, we can't rely on the requested C-state but the_actual_  state
> > and this means querying the hardware driver. Can we abstract this via
> > some interface which provides the cost of waking up a CPU? This could
> > take into account the state of the other CPUs in the cluster and the
> > scheduler is simply concerned with the wake-up costs.
> 
> can you even query this without actually waking up the cpu and asking ???

On those systems we're interested in we sure can.


Nicolas
