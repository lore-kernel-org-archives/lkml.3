Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaIIJJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:09:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:43637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaIIJJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:09:36 -0400
Date: Tue, 9 Sep 2014 11:09:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 16/22] perf: Add rb_{alloc,free}_kernel api
Message-ID: <20140909090933.GA19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-17-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QOO109bJH6q33QwK"
Content-Disposition: inline
In-Reply-To: <1408538179-792-17-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QOO109bJH6q33QwK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 20, 2014 at 03:36:13PM +0300, Alexander Shishkin wrote:
> Events that generate AUX data can also be created by the kernel. In this
> case, some in-kernel infrastructure is needed to store and copy this data.

Oh, do tell.

You really need to work on these changelogs..

--QOO109bJH6q33QwK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDsPNAAoJEHZH4aRLwOS6+wYP/3PUwnLRbyBzUp9PuReqDSHc
QK3hJOQHv13df8fuPB2E8aICLdAalptKqLktGIpdXKIDCEobkFuQPnC6AxDEhdQR
sk8gTizrYVtrKU5csrcQyvGzN3xNcQXjnJtq0dsASrRdV/pTs7S9VzMRw4GbRi9V
fa+KYCc3DkbAh7CFq8Z5GJ4HfGuc4Hi9Mnu1XrnITywZolmrovQy79wRuwmgw5hN
Gj0s3pA/6BqLwS2YwqdA8gZ+oiL1awpgs4GiU64XfOw+HjlMzyNcnkpbmdJTfMj4
5jXKqNwHlW2cdN8ksgqDe1AjpyQ3p52punFlYHBFAyrKxbgLTedTWsUtV9fV1WgD
MkfnnF9MaG18VDsZilJpnZeD/F+m4VgxklBSkSTCB23fmM84xOMXP/ZYj9Ym6thn
UjOYJKSsdWEaLl/f9OLjefqzMi3ftUnmRFlStEiRpGtPnjUx6dop+aWvCU3WPi60
PjqA8ey12h+Yb005fl8mqbuhXq8UuawyypED1ZqNqQy61KNvaoT8hYShRMt6AG+m
0m+JcIJ4le2b5G5vpcryjXzU+Bcw/EM0N/2QxeGQDzpx7RPXZ7mKG0iPQ+n6rch3
MGfKmwT7JadttQpRjOTGWMol8ktnoCbcTnB+m/shuaCzagzCeXIuc/ntOAMr77Zu
GB5WIlgB2Hp84wT8oyxJ
=dT9W
-----END PGP SIGNATURE-----

--QOO109bJH6q33QwK--
