Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaAaTGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:06:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:56045 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaTGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:06:10 -0500
Message-ID: <52EBF41E.2010608@linutronix.de>
Date: Fri, 31 Jan 2014 20:06:06 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work
 to do
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>	<1391178845-15837-2-git-send-email-bigeasy@linutronix.de> <20140131120757.594e24d6@gandalf.local.home>
In-Reply-To: <20140131120757.594e24d6@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 06:07 PM, Steven Rostedt wrote:
> The bug that I found is that if there *are* active timers, but they
> have not expired yet. Why is this a problem? Because in that case we do

Argh, right. But your patch looks also way better. After I made I was
not too happy about that amount of ifdef and wanted to redo it later.
What you just posted is a way better solution.

Sebastian
