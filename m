Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaCGPXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:23:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:38258 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaCGPXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:23:19 -0500
Message-ID: <5319E45E.20900@linutronix.de>
Date: Fri, 07 Mar 2014 16:23:10 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable-rt@vger.kernel.org
Subject: Re: [PATCH RT 3/6] rt: Make cpu_chill() use hrtimer instead of msleep()
References: <20140305003333.402759240@goodmis.org>	<20140305003346.602499217@goodmis.org>	<531996BB.2050401@linutronix.de> <20140307095223.2f412a1a@gandalf.local.home>
In-Reply-To: <20140307095223.2f412a1a@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 03:52 PM, Steven Rostedt wrote:
>> Now that you posted "cpu_chill: Add a UNINTERRUPTIBLE
>> hrtimer_nanosleep" wouldn't it make sense to delay this patches from
>> the stable series until we get them all in one go?
> 
> Sure, say this on the day I'm about to release ;-)

Haven't noticed that earlier.

> Nah, I'll release these today anyway. Otherwise I can't update to the
> mainline stables. When the rc candidates are out, it holds up any new
> updates to the versions.
> 
> Also, the stable 3.10 has this bug already. Might as well update all
> the stables with the same fix. It makes it easier on my side, as the
> way I do the updates is to use the same quilt queue for all releases. I
> start with 3.10, and get them working, and then apply the same queue to
> 3.8. Any conflicts in the patch I do a quilt fork, with a -v3.8
> appended, and then after getting that working I go to 3.4, and so on.
> This also lets me drop patches that are not applicable for earlier
> releases.
> 
> If I delay this for a new update, then 3.10 will be out of sync. I'm
> just going to release these, and then we can start a new one right away.

No worries. Do as it is easier for you.

> 
> Thanks!
> 
> -- Steve
> 
Sebastian
