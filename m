Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3J0H0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 03:26:39 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33790 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3J0H0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 03:26:37 -0400
Date: Sun, 27 Oct 2013 08:26:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131027072632.GA473@gmail.com>
References: <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
 <20131018165034.GC4019@hmsreliant.think-freely.org>
 <1382116835.3284.23.camel@edumazet-glaptop.roam.corp.google.com>
 <20131018201133.GD4019@hmsreliant.think-freely.org>
 <1382130952.3284.43.camel@edumazet-glaptop.roam.corp.google.com>
 <20131021192116.GB4154@hmsreliant.think-freely.org>
 <1382384645.3284.86.camel@edumazet-glaptop.roam.corp.google.com>
 <20131021201958.GC4154@hmsreliant.think-freely.org>
 <20131026120108.GC24067@gmail.com>
 <20131026135809.GA28375@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026135809.GA28375@neilslaptop.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> > You keep ignoring my request to calculate and account for noise of the 
> > measurement.
> 
> Don't confuse "ignoring" with "haven't gotten there yet".  [...]

So, instead of replying to my repeated feedback with a single line mail 
that you plan to address it, you repeated the same measurement mistakes 
again and again, posting invalid results, and forced me to spend time to 
repeat this same argument 2-3 times?

> [...] Sometimes we all have to wait, Ingo. [...]

I'm making bog standard technical requests to which you've not replied in 
substance, there's no need for the patronizing tone really.

Anyway, to simplify the workflow I'm NAK-ing it all until it's done 
convincingly.

  NAKed-by: Ingo Molnar <mingo@kernel.org>

I'll lift the NAK once my technical concerns and questions are resolved.

Thanks,

	Ingo
