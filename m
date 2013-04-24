Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab3DXPpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:45:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3DXPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:45:35 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=btn4o-XVpwEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=5m8K6IL_vW8A:10 a=EW-MkwFej7pXyTPL7pcA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366818332.2626.5.camel@gandalf.local.home>
Subject: Re: [PREEMPT RT] SLUB and split softirq lock for v3.2-rt
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>
Date: Wed, 24 Apr 2013 11:45:32 -0400
In-Reply-To: <517793BD.30101@linutronix.de>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
	 <1366770979.2626.3.camel@gandalf.local.home> <517793BD.30101@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 10:11 +0200, Sebastian Andrzej Siewior wrote:
> On 04/24/2013 04:36 AM, Steven Rostedt wrote:
> > Hi Sebastian,
> 
> Hi Steven,
> 
> > Which version of 3.2-rt was this applied to. It does not apply, where
> > patch 7/16 totally does not apply. I looked at the history of 3.2-rt and
> > I can't find where it would apply.
> 
> I applied them on top of 2438ee33 ("Linux 3.2.37-rt55 REBASE"). I just
> grabbed the patches from the mailing list and re-applied them on top of
> this tree and is still works.
> 

Nevermind, the problem was at my end :-(  I saved the patches as a mbox,
but evolution decided to move patch 5 to after patch 7, which broke
everything :-p

-- Steve


