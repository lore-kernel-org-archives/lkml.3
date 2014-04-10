Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591AbaDJBhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 21:37:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:40233 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933287AbaDJBhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 21:37:15 -0400
Message-ID: <1397093815.3671.156.camel@pasglop>
Subject: Re: [BUG] kernel BUG at /.../block/cfq-iosched.c:3145!
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Brian J King <bjking1@us.ibm.com>
Date: Thu, 10 Apr 2014 11:36:55 +1000
In-Reply-To: <5345F476.2000602@fb.com>
References: <1397018647.3671.123.camel@pasglop> <53454CBC.9060905@fb.com>
	 <1397087273.3671.150.camel@pasglop> <1397088144.3671.155.camel@pasglop>
	 <5345F476.2000602@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 19:31 -0600, Jens Axboe wrote:
> OK, I think we're seeing different symptoms of the same bug. Stay
> tuned, will have something for you to test shortly, I hope.

Ah thanks. I'll defer the bisection then (it's painful on that machine
for various reasons....)

This is a 64-way P7 btw, so a nice race-o-matic :-)

Cheers,
Ben.

