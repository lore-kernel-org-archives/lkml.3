Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbaGCHbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:31:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbaGCHbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:31:31 -0400
Date: Thu, 3 Jul 2014 09:31:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, Waiman.Long@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Cancellable MCS spinlock rework
Message-ID: <20140703073107.GS19379@twins.programming.kicks-ass.net>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
 <20140702162749.GP19379@twins.programming.kicks-ass.net>
 <1404320356.3170.12.camel@j-VirtualBox>
 <20140702172333.GQ19379@twins.programming.kicks-ass.net>
 <1404322203.3170.17.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cxMSjUqMQBJIqbX5"
Content-Disposition: inline
In-Reply-To: <1404322203.3170.17.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cxMSjUqMQBJIqbX5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 02, 2014 at 10:30:03AM -0700, Jason Low wrote:
> Would potentially reducing the size of the rw semaphore structure by 32
> bits (for all architectures using optimistic spinning) be a nice
> benefit?

Possibly, although I had a look at the mutex structure and we didn't
have a hole to place it in, unlike what you found with the rwsem.

--cxMSjUqMQBJIqbX5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtQa2AAoJEHZH4aRLwOS6+i4P/jm5zge4BYaDN0NKbCco8/E5
6SW3Fe5jHQ2awMKb6DgmvOGC6dvD+vKqIHVkzVOSTjULdqUweAtaMj6r6UYHxr8v
OKQn/Kkk1gHfwoFx/zchyE5Ic6gysWP1uKl2SS/VW1oetFXkPsHDLWl29tuKBkT0
YnpVMqFKvOGzCBu1kRb7ZJoDBU4uOXmI4a9+xeurl3D8tQybxifGkmqTfZVhxc//
jft6U0tAoZet+WTUmsF+cU9nXWkgs13M/DIQ/zOedKRB2s2PI2sRZspQKlgl5Dem
jt2m1bCRPwgCvmPHrPDgih6tfe0gtD8sS4Yw7QieikHsGfhmGsS9+YsxgCVN2b2i
0oChKy5xHWSyvFFelz8zkfQmfjiIqpiPjcT0YmSulEGxUwcNxu60PIlJD47DTp8E
bSOXYoeqjqJBc5H6jaLRIdf5ZVp1jZAFPPXLL6LT57RwT5VJ5YuPxo/EPFxDp3Se
9KEfmPOYKVWLpzTI9U6yhT7vCEVowJcj/cweAEcFiiVgwHXyVBmRmr3gFOYhtBc0
LRnR9M92yFL6XzJ9JbfZ5nWpc19OmE1Ly6G+kUrCXwzxndvFjB2ja/H+iiTzaDK+
0QcGPDVYn/j+WYhU+UZl7HRgx7TFizYzlKLtcCQVgNfpfIBXEqJ7JcIHyqXnE8Gf
3P6p7a2GyzRvazsfog8T
=fbmn
-----END PGP SIGNATURE-----

--cxMSjUqMQBJIqbX5--
