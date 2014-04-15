Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaDONNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:13:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54900 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaDONNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:13:20 -0400
Date: Tue, 15 Apr 2014 15:13:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alex Shi <alex.shi@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: Re: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle
 info
Message-ID: <20140415131311.GM11182@twins.programming.kicks-ass.net>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
 <CAKfTPtC4E=7DxnXZy8bSpeAqyLwsr-oXodXBod2aMc_x4VyqGg@mail.gmail.com>
 <53398FE6.1090203@linaro.org>
 <CAKfTPtBiFUM90igrhz=VnvSkt9MQ2E-xxnzDf=wSKdK+qA4EQA@mail.gmail.com>
 <533A6E3D.4040002@linaro.org>
 <CAKfTPtCH0AhxM8TUeqjnnFVmpLd1D39B4gV2SaWmHX21iLNVuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtCH0AhxM8TUeqjnnFVmpLd1D39B4gV2SaWmHX21iLNVuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 11:05:16AM +0200, Vincent Guittot wrote:
> >> We are working on a bench which can generate middle load pattern with
> >> idle CPUs but it's not available yet. In the mean time, one bench that
> >> plays with idle time is cyclictest, it will not give you performance
> >> results but only scheduling latency which might be what you are
> >> looking for.
> >
> >
> > Yeah, thanks. I believe I know what is in the rt-tests package :)
> >
> > What I meant is what kind of values would you like to see with this patchset
> > ?
> 
> IIUC, you patch tries to improve the wake up latency of a task by
> selecting the CPUs with the shallowest C-state, so this metrics seems
> to be a good candidate

cyclic-test might be too regular to really measure anything though.
