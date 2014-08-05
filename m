Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaHEOy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:54:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaHEOy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:54:57 -0400
Date: Tue, 5 Aug 2014 16:54:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v6] locking/selftest: Support queued rwlock
Message-ID: <20140805145437.GL9918@twins.programming.kicks-ass.net>
References: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com>
 <1406659999-13974-3-git-send-email-Waiman.Long@hp.com>
 <20140805132837.GA19379@twins.programming.kicks-ass.net>
 <CAKocOOMa89+Ej0rk-LyQLBcwDvLtsXq7x+oPwBMS1N61kKUwQg@mail.gmail.com>
 <20140805144108.GK9918@twins.programming.kicks-ass.net>
 <53E0EDD2.50600@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUR78EuMd8EhT3+C"
Content-Disposition: inline
In-Reply-To: <53E0EDD2.50600@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUR78EuMd8EhT3+C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2014 at 04:44:34PM +0200, Maarten Lankhorst wrote:
> op 05-08-14 16:41, Peter Zijlstra schreef:

> >> A bit off topic for this patch, however relevant for tests in general.
> >> Is there a reason why these locking selftests need to be under lib?
> >> Can they be consolidated under tools/testing/selftests?
> > tools/ seems wrong as its very much not userspace.
> Could be moved to kernel/locking though now that all other locking moved there. :-)

Yes, I suppose we could do that; IIRC the reason I left it where it is
is because there are more tests in lib/.

--CUR78EuMd8EhT3+C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4PAtAAoJEHZH4aRLwOS6KS4P/1SG0l5aJ4ARosgq2BdAG2pA
UfLlb0M+WmHAge4mOFfbyZunFBqJ/7p2hhATWLwUW+/o7X9V+TI0QoZGkTB5ePv0
Z/jchoe1XHVnS3aaU45U36+3g/DlzDVxONBtmBoEXve2pmqb9gDhX/iG5vyRzl5P
oby/qqvCBdiUZDBT/wZt9NlI6f4OO49Ea5KXobFjK6+MS8XDKmZrofVY9DOw5bQi
kDnUCvAhLRbfLO7jR6o6IJ3IKmRBl4Y/RpeFCJ2XADbFDjzG51z71Hx6vj2Em1+t
9wKHiLetC6l/xYiZ+5Wo8LvpAetw0a7WSBDLjmptLUatBcn5XdZwQexekGdUsZwn
O4+lPw5n1jkWkyGtVqCavO1xQCXVDyozx7yD3YM7pAmK5o3MX8r9wOex1OTAKgIs
nuBwNHQHNTMH8BUZi++pL5hHPXzS3cCcnpOY/2Jy971cCqPh9Vqd380tnG1fCOdb
xel+oS4hfWnAoZ7TU2lb+V9EfJGWucUqPQ0iJGiyLnCpIT6mS1BzbkBNy8pFFV1V
MCDnAsYzmRMYpqaUH6sj9dPQaWDFPNu6xloJh1AVuS9OiWZdK0IdTHtsk+n0ScUB
EGMg6f4t5yGzYacwxqqg6yTJEM0kp+cz2+N4fkEcIKhmSI3vVgdYCT9OfMqJcAJ4
yqghQJD2w5MGP9Ve9Str
=Unea
-----END PGP SIGNATURE-----

--CUR78EuMd8EhT3+C--
