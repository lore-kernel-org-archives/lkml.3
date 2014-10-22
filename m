Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaJVWou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 18:44:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483AbaJVWos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 18:44:48 -0400
Message-ID: <1414017873.30946.105.camel@localhost>
Subject: Re: Regression: audit: x86: drop arch from __audit_syscall_entry()
 interface
From: Eric Paris <eparis@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paulo Zanoni <przanoni@gmail.com>,
        Richard Guy Briggs <rgb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Date: Wed, 22 Oct 2014 18:44:33 -0400
In-Reply-To: <544824F3.9000808@zytor.com>
References: <CA+gsUGSiXf2gpB8QQOQOmgxFc8mx31V6qeRqow6aXO1195jWEA@mail.gmail.com>
		 <1414002190.30946.95.camel@localhost>
		 <alpine.DEB.2.11.1410222323500.5308@nanos>
	 <1414013897.30946.102.camel@localhost> <544824F3.9000808@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 14:43 -0700, H. Peter Anvin wrote:
> On 10/22/2014 02:38 PM, Eric Paris wrote:
> > 
> > It was sent, numerous times, to the x86 list for reviews, and lived in
> > -next for 2 complete devel cycles without a complaint.  I'm trying to
> > get an i386 system to test a fix.  But yes, it's total crap.
> > 
> 
> You don't need an i386 system -- you can install an i386 distro on an
> x86-64 system, or in KVM.

So I might still be an idiot, because I still haven't gotten a working
kernel.  But I can't get Linus' latest not panic even without
CONFIG_AUDITSYSCALL.  I kept blaming myself for not fixing this problem,
but reverting the patch like the reporter didn't give me bootable
kernels either.

I just jumped back in time and am looking to get anything I build to
boot...

