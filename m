Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283Ab3BMSFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:05:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3365 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965140Ab3BMSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:05:32 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RxdSD2jLC48A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=sjSJRsSX_X4A:10 a=55-GXWVWCCrusDdHabEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360778730.23152.11.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH RT] acpi/rt: Convert acpi lock back to a
 raw_spinlock_t
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, John Kacur <jkacur@gmail.com>,
        Clark Williams <clark@redhat.com>
Date: Wed, 13 Feb 2013 13:05:30 -0500
In-Reply-To: <1360777892.23152.9.camel@gandalf.local.home>
References: <1360765565.23152.5.camel@gandalf.local.home>
	 <alpine.LFD.2.03.1302131744590.13701@tycho>
	 <alpine.LFD.2.02.1302131755230.11905@ionos>
	 <1360777892.23152.9.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 12:51 -0500, Steven Rostedt wrote:
> On Wed, 2013-02-13 at 18:21 +0100, Thomas Gleixner wrote:
> > On Wed, 13 Feb 2013, John Kacur wrote:
> > > 
> > > Thanks Steven. That looks way better than the previous revert.
> > 
> > I can't tell as I haven't seen the previous revert. And looks good is
> > not really a good review criteria.
> 
> I agreed, and warned John on IRC about that. This is why the patch had
> RFC in the subject.
> 

I should specify that I warned John before he emailed. He wasn't giving
his ack to the patch, as he already knew it was a test patch only. It
just looked as if he did, and my reply didn't help the perspective.

;-)

-- Steve


