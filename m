Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab3DYOgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:36:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab3DYOgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:36:10 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BTRBD928usAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YPD5nf4ZmOMA:10 a=JCVdk7nW1KsPPEWOOGsA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366900568.10248.16.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
From: Steven Rostedt <rostedt@goodmis.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 25 Apr 2013 10:36:08 -0400
In-Reply-To: <3603730.i3rZKahVeu@dabox>
References: <1366760662.9609.176.camel@gandalf.local.home>
	 <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de>
	 <3603730.i3rZKahVeu@dabox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 16:22 +0200, Tim Sander wrote:

> As we also have also PREEMPT_RT_FULL set the proposed solution to 
> allow only PREEMPT_RT_FULL with PREEMPT_RT_FULL set is not an option for us.

Then I think you have issues ;-)

-- Steve



