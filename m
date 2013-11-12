Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3KLMgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:36:04 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48947 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3KLMgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:36:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
	<CAHkRjk69GNYtLGBSWCNcsCzkBHywKrD0qQQbNkJRpMbcdsCPyw@mail.gmail.com>
Date: Tue, 12 Nov 2013 13:35:59 +0100
Message-ID: <CAKfTPtBa-q6Uyxog1ELD35LF41o5zguJWiYgub5rqJm4ejdMPQ@mail.gmail.com>
Subject: Re: [RFC][PATCH v5 00/14] sched: packing tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Luck <tony.luck@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>,
        Alex Shi <Alex.Shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2013 12:33, Catalin Marinas <catalin.marinas@arm.com> wrote:
> Hi Vincent,
>
> (cross-posting to linux-pm as it was agreed to follow up on this list)
>

<snip>

>
> So, IMO, defining the power topology is a good starting point and I
> think it's better to separate the patches from the energy saving
> algorithms like packing. We need to agree on what information we have

Daniel and Tuukka who are working in cpuidle consolidation in the
scheduler, are also interested in using similar topology information
than me. I have made 1 patchset only because the information was only
used here. So I can probably make a separate patchset of the power
topology description in DT.

Vincent

> (C-state details, coupling, power gating) and what we can/need to
> expose to the scheduler. This can be revisited once we start
> implementing/refining the energy awareness.
>

<snip>
>
> --
> Catalin
