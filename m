Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaIJKS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:18:28 -0400
Received: from bay004-omc1s17.hotmail.com ([65.54.190.28]:49362 "EHLO
	BAY004-OMC1S17.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbaIJKS1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:18:27 -0400
X-TMN: [dWQWhjpXNzTJuwkksnLx/bKK3cytBYdy]
X-Originating-Email: [kasper01_77@hotmail.com]
Message-ID: <BAY180-W58C1DE82E5DB74292DF13D8FCF0@phx.gbl>
From: Onorato Vaticone <kasper01_77@hotmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Scheduler algorithm
Date: Wed, 10 Sep 2014 12:18:27 +0200
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 10 Sep 2014 10:18:27.0074 (UTC) FILETIME=[8F95E620:01CFCCE0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have a doubt to clarify.

any scheduler class manage the "pick_next_task" internally (e.g.: CFS use a red-black tree and the "fair" algorithm, etc). 
The main scheduler just:

class = sched_class_highest;

for ( ; ; ) {

   p = class->pick_next_task(rq);

      if (p)

         return p;

/// ...


my question is from the "big picture" point of view:
when the scheduler ask for a new task as to the "highest class" first (RR/FIFO policy) and then stepping to the  next one (CFS). 
But, doesn't this treat the CFS process at the same level of the real time process? 
I mean the scheduler ask first to the rt_sched_class and then fair_sched_class ... in a for ... 

can you clarify, please where the "real time" task are different?
thanks in advance!

I'd like to be in cc'ed on this.

Kasper. 		 	   		  