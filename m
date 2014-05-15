Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbaEOQPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:15:36 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:58067 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaEOQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:15:35 -0400
Date: Thu, 15 May 2014 12:15:33 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 0/6] sched: expel confusing usage of the term "power"
In-Reply-To: <CAKfTPtAtiiWN9t_VswTienkBBCiUpqnZdvsnOVnTphc0PF69Rg@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1405151214171.17310@knanqh.ubzr>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org> <CAKfTPtAtiiWN9t_VswTienkBBCiUpqnZdvsnOVnTphc0PF69Rg@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Vincent Guittot wrote:

> Hi Nico,
> 
> Thanks for doing this renaming.
> I remember that you asked me to do this while working on cpu_power but
> my work has not evolved as fast as expected and as it already implies
> some renaming other than s/power/capacity/ i have postponed it to not
> make review to complex.
> 
> Nevertheless, i can manage the conflicts afterward and rebase my
> patches, depending of the review status

OK.  Could you provide review status of your own then?


Nicolas
