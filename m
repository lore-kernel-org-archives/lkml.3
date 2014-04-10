Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbaDJGqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 02:46:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:53941 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaDJGqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 02:46:00 -0400
Message-ID: <1397112333.3671.179.camel@pasglop>
Subject: Re: [BUG] kernel BUG at /.../block/cfq-iosched.c:3145!
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Brian J King <bjking1@us.ibm.com>
Date: Thu, 10 Apr 2014 16:45:33 +1000
In-Reply-To: <5346158B.90005@fb.com>
References: <1397018647.3671.123.camel@pasglop> <53454CBC.9060905@fb.com>
	 <1397087273.3671.150.camel@pasglop> <1397088144.3671.155.camel@pasglop>
	 <5345F476.2000602@fb.com> <1397093815.3671.156.camel@pasglop>
	 <5346012A.50901@fb.com> <1397100937.3671.160.camel@pasglop>
	 <5346158B.90005@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 21:52 -0600, Jens Axboe wrote:
> On 2014-04-09 21:35, Benjamin Herrenschmidt wrote:
> > On Wed, 2014-04-09 at 20:25 -0600, Jens Axboe wrote:
> >> On 2014-04-09 19:36, Benjamin Herrenschmidt wrote:
> >>> On Wed, 2014-04-09 at 19:31 -0600, Jens Axboe wrote:
> >>>> OK, I think we're seeing different symptoms of the same bug. Stay
> >>>> tuned, will have something for you to test shortly, I hope.
> >>>
> >>> Ah thanks. I'll defer the bisection then (it's painful on that machine
> >>> for various reasons....)
> >>
> >> Can you try with these two patches applied?
> >
> > Booted to login prompt once ... and twice. Much better ! :-)
> 
> Excellent! I was hoping it was the same bug :-)
> I'll amend the commit and add your tested-by.

A colleague was complaining of yet another oddball block related crash
today on another machine when doing rsync's with upstream (this machine
booted fine but crashed later on, but then it has less CPUs... maybe
that's relevant) and these patches fixed it too.

Cheers,
Ben.


