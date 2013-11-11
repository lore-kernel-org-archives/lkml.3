Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3KKT1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:27:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:30162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab3KKT1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:27:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,679,1378882800"; 
   d="scan'208";a="425748142"
Message-ID: <52812F6D.8090404@linux.intel.com>
Date: Mon, 11 Nov 2013 11:26:37 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
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
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org> <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com> <20131111165453.GB4586@e103034-lin> <20131111183142.GF29572@arm.com>
In-Reply-To: <20131111183142.GF29572@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 10:31 AM, Catalin Marinas wrote:
> I agree, we can't rely on the requested C-state but the_actual_  state
> and this means querying the hardware driver. Can we abstract this via
> some interface which provides the cost of waking up a CPU? This could
> take into account the state of the other CPUs in the cluster and the
> scheduler is simply concerned with the wake-up costs.

can you even query this without actually waking up the cpu and asking ???

