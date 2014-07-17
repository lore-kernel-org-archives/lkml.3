Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaGQSzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:55:55 -0400
Received: from wolff.to ([98.103.208.27]:53418 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751527AbaGQSzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:55:54 -0400
Date: Thu, 17 Jul 2014 13:54:19 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140717185419.GA4723@wolff.to>
References: <20140716145546.GA6922@wolff.to>
 <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
 <20140716195414.GA16401@wolff.to>
 <53C7084C.7090104@arm.com>
 <20140717030947.GA17889@wolff.to>
 <53C79013.1020808@arm.com>
 <20140717163627.GA2489@wolff.to>
 <53C81944.5080203@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <53C81944.5080203@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 20:43:16 +0200,
  Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>
>If you could apply the patch:
>
>https://lkml.org/lkml/2014/7/17/288
>
>and then run it on your machine, that would give us more details, i.e. 
>the information on which sched_group(s) and in which sched domain 
>level (SMT and/or DIE) this issue occurs.
>
>
>Another thing which you could do is to boot with an extra 
>'earlyprintk=keep sched_debug' in your command line options with a 
>build containing the cpumask_clear() in build_sched_groups() and 
>extract the dmesg output of the scheduler-setup code:

I'll see what I can do. I have plans after work today and I don't know 
if I'll be awake enough when I get home to followup tonight or early 
tomorrow. Worst case will be over the weekend.
