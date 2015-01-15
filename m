Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbbAOKiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:38:01 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:43904 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbAOKh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:37:59 -0500
Date: Thu, 15 Jan 2015 11:37:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] x86/entry changes for 3.20, round 1
Message-ID: <20150115103754.GC1698@gmail.com>
References: <CALCETrVCmoEP-Ha937VurRVxYYmSG==QL=twMBUWgzOAxc4uRA@mail.gmail.com>
 <20150115092740.GY9719@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115092740.GY9719@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Jan 14, 2015 at 05:59:26PM -0800, Andy Lutomirski wrote:
> > Hi Ingo and Thomas,
> > 
> > At Linus' suggestion, I'm trying out some maintainerish stuff for x86
> > entry code.  Please consider pulling to an appropriate branch *after
> > Paul sends his RCU pull request*, only if 734d16801349 is included in
> > that pull request.  If this goes well, maybe I'll submit a MAINTAINERS
> > patch, too.
> > 
> > IMPORTANT: This is based on an RCU change that you don't have yet.  I
> > think that Paul is planning on sending a pull request with that change
> > fairly soon.  The code in here would compile without that fix, but it
> > would introduce a nasty regression, so, to avoid breaking bisection, I
> > based this off of the relevant change in Paul's tree.  (It's the very
> > first change for 3.20 in his current queue.)
> 
> Yep, should happen by early next week, if it survives this weekend's
> testing.  ;-)

Ok, I'll first wait for that pull request to arrive then.

Thanks,

	Ingo
