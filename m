Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaCGJwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:52:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:35290 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaCGJwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:52:03 -0500
Message-ID: <531996BB.2050401@linutronix.de>
Date: Fri, 07 Mar 2014 10:51:55 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable-rt@vger.kernel.org
Subject: Re: [PATCH RT 3/6] rt: Make cpu_chill() use hrtimer instead of msleep()
References: <20140305003333.402759240@goodmis.org> <20140305003346.602499217@goodmis.org>
In-Reply-To: <20140305003346.602499217@goodmis.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 01:33 AM, Steven Rostedt wrote:
> 3.2.55-rt79-rc1 stable review patch.
> If anyone has any objections, please let me know.

Now that you posted "cpu_chill: Add a UNINTERRUPTIBLE
hrtimer_nanosleep" wouldn't it make sense to delay this patches from
the stable series until we get them all in one go?

Sebastian

