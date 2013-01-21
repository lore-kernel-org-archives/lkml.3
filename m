Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3AUJSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:18:21 -0500
Received: from matrix.voodoobox.net ([75.127.97.206]:41102 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3AUJSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:18:20 -0500
Message-ID: <1358759881.2595.15.camel@obelisk.thedillows.org>
Subject: Re: IPsec AH use of ahash
From: David Dillow <dave@thedillows.org>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 21 Jan 2013 04:18:01 -0500
In-Reply-To: <861997288.94032.1358728848956.JavaMail.root@elliptictech.com>
References: <861997288.94032.1358728848956.JavaMail.root@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-20 at 19:40 -0500, Tom St Denis wrote:
> The problem is for me to add the ()'s is a no brainer.

It was more than just the ()'s. You completely botched the indentation
in the parts of code you didn't copy from xcbc.c, among other issues.

> For me to re-write complete statements for coding style reasons means
> I have to actually go out and test it again.

Well, for some of the code you submitted, that would be the first
testing it got, even compile testing AFAICT. I don't doubt that you
tested against your hardware, but it is obvious that you didn't run the
algorithm tests you added, or even tried to compile them. You were
missing a semicolon after your test data, and you were also missing a
"\x" in there, so your test data was wrong.

I know this, because I just spent the five minutes required to fix up
the checkpatch warnings to prove to myself that you could have done it
faster than sending one considered message to the list about how much we
suck. Of course, that assumes you are trying to have a discussion
instead of trolling; it's much easier to spew bile than to think before
you post.

