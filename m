Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaCGJts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:49:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:35243 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaCGJtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:49:46 -0500
Message-ID: <53199636.7010806@linutronix.de>
Date: Fri, 07 Mar 2014 10:49:42 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>, uobergfe@redhat.com
Subject: Re: [PATCH RT] cpu_chill: Add a UNINTERRUPTIBLE hrtimer_nanosleep
References: <20140304122832.0979c5dc@gandalf.local.home>
In-Reply-To: <20140304122832.0979c5dc@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 06:28 PM, Steven Rostedt wrote:
> We hit another bug that was caused by switching cpu_chill() from
> msleep() to hrtimer_nanosleep().

Applied with a stable tag.

Sebastian

