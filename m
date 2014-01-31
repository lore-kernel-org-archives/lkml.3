Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbaAaUBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:01:40 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:37492 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaAaUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:01:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140131140941.GF4941@twins.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	<1390936396-3962-6-git-send-email-jason.low2@hp.com>
	<20140128210753.GJ11314@laptop.programming.kicks-ass.net>
	<1390949495.2807.52.camel@j-VirtualBox>
	<20140129115142.GE9636@twins.programming.kicks-ass.net>
	<1391138977.6284.82.camel@j-VirtualBox>
	<20140131140941.GF4941@twins.programming.kicks-ass.net>
Date: Fri, 31 Jan 2014 12:01:37 -0800
X-Google-Sender-Auth: ZMpct9-lVOwj08TKRG8w7O5gNHI
Message-ID: <CAGQ1y=72+N4=yjVpjsTKjr-8xSQRS2xw4gcOGOipLgwPwgnA7A@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, chegu_vinod@hp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 6:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> I've downloaded AIM7 from sf.net and I hope I'm running it with 100+
> loads but I'm not entirely sure I got this thing right, its not really
> making progress with or without patch :/

Ingo's program http://lkml.org/lkml/2006/1/8/50 using the V option may
be able to generate similar mutex contention.

Currently still getting soft lockups with the updated version.
