Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3LOTd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 14:33:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:56649 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3LOTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 14:33:55 -0500
Message-ID: <52AE0419.3050103@linutronix.de>
Date: Sun, 15 Dec 2013 20:33:45 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>, 723180@bugs.debian.org,
        Brian Silverman <bsilver16384@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Double fault when single-stepping compat task with PREEMPT_RT
References: <20130917061329.4872.51468.reportbug@dell-inspiron-linux.dlinkrouter>  <1379427451.23881.48.camel@deadeye.wl.decadent.org.uk>  <CAP01z6LVxoA6kDJeL8NuO2aA22BjMvXSk9ZY7z9cOK1=k56vpg@mail.gmail.com>  <1379905562.3913.8.camel@deadeye.wl.decadent.org.uk>  <CAP01z6+j6moUio9pc3G3iz+ebJCdKEvngddxnxazRP+NXwLkyg@mail.gmail.com> <1380115449.4430.21.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1380115449.4430.21.camel@deadeye.wl.decadent.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 03:24 PM, Ben Hutchings wrote:
> On Tue, 2013-09-24 at 13:43 -0700, Brian Silverman wrote: [...]
>> I got down to a really simple program that reproduces this bug:
>> 
>> 
>> #include <sys/syscall.h> #include <unistd.h> int main() { // I've
>> tried SYS_getpid, SYS_write, and SYS_read here too. 
>> syscall(SYS_gettid); }

Brian, thank you for this excellent stripped down test case.
I think I know what is going on, will dig more later.

> Ben.
> 

Sebastian
