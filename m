Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaAXUnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:43:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:59592 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaAXUm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:42:58 -0500
Message-ID: <52E2D049.3060800@linutronix.de>
Date: Fri, 24 Jan 2014 21:42:49 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <bitbucket@online.de>,
        Joakim Hernberg <jbh@alchemy.lu>, Joe Korty <joe.korty@ccur.com>,
        Muli Baron <muli.baron@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RT v2] timer: Raise softirq if there's irq_work
References: <20140124145157.1f30d447@gandalf.local.home> <20140124150933.22d8c20a@gandalf.local.home> <20140124202039.GA32662@linutronix.de> <20140124153542.6a92ef27@gandalf.local.home>
In-Reply-To: <20140124153542.6a92ef27@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 09:35 PM, Steven Rostedt wrote:
> 
> I know we discussed this on IRC, but I wanted to publicly state that
> the missing irq work callback was the RCU's rsp_wakeup() function.

Let me add that part to that commit message since I can't find it.

> 
> -- Steve

Sebastian

