Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbaCSMbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:31:00 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:62375 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbaCSMa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:30:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140319120555.GL27632@laptop.programming.kicks-ass.net>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
 <1395165409-18055-8-git-send-email-vincent.guittot@linaro.org> <20140319120555.GL27632@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 19 Mar 2014 13:30:26 +0100
Message-ID: <CAKfTPtAMVoZbdqafwCmU3mGeO+UiXEamtwqF-MMLsEqQnSc8FQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] sched: powerpc: Add SD_SHARE_POWERDOMAIN for SMT level
To: Peter Zijlstra <peterz@infradead.org>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 13:05, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Mar 18, 2014 at 06:56:49PM +0100, Vincent Guittot wrote:
>> Set the power domain dependency at SMT level of Power8 but keep the flag
>> clear at CPU level. The goal is to consolidate tasks on the threads of a
>> core up to a level as decribed in the link below:
>> https://lkml.org/lkml/2014/3/12/16
>
> I've not yet looked at the link; but its best to avoid references and
> have a Changelog that can stand on its own.

I can copy/paste Preeti's explanation in the commit message

>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
