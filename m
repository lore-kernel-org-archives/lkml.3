Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaIKJ16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:27:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35669 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaIKJ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:27:56 -0400
Date: Thu, 11 Sep 2014 11:27:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v5 08/12] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140911092732.GS3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org>
 <54020F00.2030807@linux.vnet.ibm.com>
 <CAKfTPtBq89SX=7=bXu2za7oXi1Lid_5ara-WputrtE8kCqcZcw@mail.gmail.com>
 <5406DB43.1030506@linux.vnet.ibm.com>
 <CAKfTPtCXBYSbXVgdeyMtvuK8aZaRBzhs9S3=+V2jvXnoCJFqBQ@mail.gmail.com>
 <540708DC.9060901@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540708DC.9060901@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 05:56:04PM +0530, Preeti U Murthy wrote:
> On 09/03/2014 05:14 PM, Vincent Guittot wrote:
> > On 3 September 2014 11:11, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> >> On 09/01/2014 02:15 PM, Vincent Guittot wrote:
> >>> On 30 August 2014 19:50, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> >>>> Hi Vincent,
> >>>>> index 18db43e..60ae1ce 100644

Guys, really, trim excess crap. This email had over 150 lines of garbage
and 5 pointless quote levels or so before there was anything useful.
