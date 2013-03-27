Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3C0Itn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:49:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39721
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953Ab3C0Itl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:49:41 -0400
Message-ID: <1364374174.5053.59.camel@laptop>
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 27 Mar 2013 09:49:34 +0100
In-Reply-To: <51527C17.3070901@intel.com>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	 <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org>
	 <1364302359.5053.21.camel@laptop>
	 <CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com>
	 <1364308932.5053.46.camel@laptop>
	 <CAKfTPtDo3dmEZU-R62unQH9j5CxZWJj+Ws5CTBptOzTohkNJMA@mail.gmail.com>
	 <51527C17.3070901@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 12:56 +0800, Alex Shi wrote:

> Just one buddy to pack tasks for whole level cpus definitely has
> scalability problem.

Right, but note we already have this scalability problem in the form of
the ILB. Some people were working on sorting that but then someone
changed jobs and I think it fell in some deep and dark crack.

Venki, Suresh?

