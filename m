Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaHFPCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:02:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57493 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaHFPC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:02:29 -0400
Date: Wed, 6 Aug 2014 08:02:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Anand Moon <moon.linux@yahoo.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq_opp.c: Fixed the __might_sleep by changing
 GFP_KERNEL to GFP_ATOMIC.
Message-ID: <20140806150227.GA32301@codeaurora.org>
References: <1407183283-21921-1-git-send-email-moon.linux@yahoo.com>
 <CAKohpo=j59=5fmVAdhGXkdb3YHN6zDQBkibZZTfc73GvSqx=3A@mail.gmail.com>
 <5600331.UfWMPf73u1@vostro.rjw.lan>
 <CAKohpo=VQEtmSLE5-fQ8=zb-kkRYN8kZeaBPzMV5rF=WxxmeDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=VQEtmSLE5-fQ8=zb-kkRYN8kZeaBPzMV5rF=WxxmeDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Viresh Kumar wrote:
> On 6 August 2014 05:05, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> https://lkml.org/lkml/2014/7/16/815
> >>
> >> @Rafael: Have you already applied patch from above link?
> >
> > No, I haven't.  Do we need it after all?
> 
> I think yes, Right Stephen? :)

Yes.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
