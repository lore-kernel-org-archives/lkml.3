Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaEBNGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:06:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:14313 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751650AbaEBNGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:06:42 -0400
Date: Fri, 2 May 2014 09:06:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RT 1/3] rt: Move migrate_disable up in trylocks
Message-ID: <20140502090626.1467f8f2@gandalf.local.home>
In-Reply-To: <5363451B.8080300@linutronix.de>
References: <20140501004757.583708392@goodmis.org>
	<20140501005004.241785945@goodmis.org>
	<5363451B.8080300@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2014 09:11:23 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 05/01/2014 02:47 AM, Steven Rostedt wrote:
> 
> Could this wait until it appears in the development release?

I would need to delay the release then as I wont release a kernel that
fails the cpu stress test.

I don't have a problem with delaying this though.

-- Steve
