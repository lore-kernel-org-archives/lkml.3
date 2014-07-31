Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaGaOhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:37:43 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:53411 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaGaOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <1406817052.17194.12.camel@marge.simpson.net>
References: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
	<20140731115759.GS19379@twins.programming.kicks-ass.net>
	<CALFYKtBGQpxaZ0EFXbdvuEHeDeASeU-7XxQ_1a6ZDM=aJS651w@mail.gmail.com>
	<20140731131331.GT19379@twins.programming.kicks-ass.net>
	<1406817052.17194.12.camel@marge.simpson.net>
Date: Thu, 31 Jul 2014 18:37:40 +0400
Message-ID: <CALFYKtDxF_NApZ010W7-BGCf4fkXSYca_g1=Kn8jV_jrf2tWGA@mail.gmail.com>
Subject: Re: [PATCH] locking/mutexes: Revert "locking/mutexes: Add extra
 reschedule point"
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>, davidlohr@hp.com,
        jason.low2@hp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 6:30 PM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Thu, 2014-07-31 at 15:13 +0200, Peter Zijlstra wrote:
>
>> Smells like maybe current->state != TASK_RUNNING

It just triggered for me too, took longer than usual.  Sorry for the
churn Peter, this was really confusing.  Onto finding the real bug..

Thanks,

                Ilya
