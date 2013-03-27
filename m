Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3C0IvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:51:25 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39745
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab3C0IvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:51:23 -0400
Message-ID: <1364374274.5053.60.camel@laptop>
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Date: Wed, 27 Mar 2013 09:51:14 +0100
In-Reply-To: <51527A08.8060207@intel.com>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	 <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
	 <1364301443.5053.9.camel@laptop> <5152768B.3020306@linux.vnet.ibm.com>
	 <51527A08.8060207@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 12:48 +0800, Alex Shi wrote:
> 
> Yes, the new forked runnable load was set as full utilisation in V5
> power aware scheduling. PJT, Mike and I both agree on this. PJT just
> discussion how to give the full load to new forked task. and we get
> agreement in my coming V6 power aware scheduling patchset.

Great!, means I can mark the v5 thread read! :-)

