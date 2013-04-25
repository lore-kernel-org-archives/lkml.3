Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab3DYWXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:23:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab3DYWXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:23:23 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BTRBD928usAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YPD5nf4ZmOMA:10 a=Mn597_HhJwhjV_jeDdoA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366928600.10248.20.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Sander <tim.sander@hbm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 25 Apr 2013 18:23:20 -0400
In-Reply-To: <alpine.LFD.2.02.1304260018470.21884@ionos>
References: <1366760662.9609.176.camel@gandalf.local.home>
	 <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de>
	 <3603730.i3rZKahVeu@dabox> <alpine.LFD.2.02.1304260018470.21884@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 00:20 +0200, Thomas Gleixner wrote:
> Tim,
> 
> On Thu, 25 Apr 2013, Tim Sander wrote:
> > handler. But normally the HR_TIMER is set. So we switched it off on this very 
> > purpose. As we also have also PREEMPT_RT_FULL set the proposed solution to 
> > allow only PREEMPT_RT_FULL with PREEMPT_RT_FULL set is not an option for us.
> 
> -ENOPARSE

I think he made a typo and was referring to my post. I think he meant
that they require not having high res timers set when PREEMPT_RT_FULL is
set. As you stated to me before.

-- Steve


