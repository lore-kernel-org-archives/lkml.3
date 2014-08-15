Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaHOOAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:00:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49391 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaHOOAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:00:36 -0400
Date: Fri, 15 Aug 2014 16:00:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
Message-ID: <20140815140006.GH19379@twins.programming.kicks-ass.net>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
 <20140814205143.GY6758@twins.programming.kicks-ass.net>
 <CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
 <20140815061917.GX19379@twins.programming.kicks-ass.net>
 <CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>
 <53EE0E5B.3050004@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUFRbl9plnVqmeZZ"
Content-Disposition: inline
In-Reply-To: <53EE0E5B.3050004@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CUFRbl9plnVqmeZZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2014 at 06:42:51AM -0700, Arjan van de Ven wrote:
> On 8/15/2014 6:08 AM, Ashwin Chaugule wrote:
> >(b) we come up with ways to provide the bounds around a Desired value
> >using the information from the platform. (long term)
> >
> >I briefly looked at the x86 HWP (Hardware Performance States) in the
> >s/w manual again. Its essentially an implementation of CPPC. It seems
> >like X86 has implemented most if not all these registers as MSRs. I'm
> >really interested in knowing if anyone there is/has been working on
> >using them and what they found.
>=20
> we've found that so far that there are two reasonable options
> 1) Let the OS device (old style)
> 2) Let the hardware decide (new style)
>=20
> 2) is there in practice today in the turbo range (which is increasingly t=
he whole thing)
> and the hardware can make decisions about power budgetting on a timescale=
 the OS
> can never even dream of, so once you give control the the hardware (with =
CPPC or native)
> it's normally better to just get out of the way as OS.

OK, so we should just forget about 'power aware scheduling' for Intel?

--CUFRbl9plnVqmeZZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7hJmAAoJEHZH4aRLwOS6gF0P/1yJ9Ht+vY2boUat2F9RdYvc
XGFpedppVZqDX1PEQP7KR5PZIctyI12rFcTfFeHgXc6M2DrS3BTOtKRfsgDzjgi5
kNmhTMfqk6DCshwFu0wK4sXJDzYbTyNE01yCe6C8nqNio7w4Ajycq9ePjies9Eev
mlQmJooCaarQ1OvyhLmqA6ijy/sfr+HIOAhNn6YG3D8unOmfV9mXTZG9IQ4zYCm7
TO6pSIsc6dJ5JsZu+evTMFLCQ17/1vjc/sDtd4/fyn6NUg7+LnMbKC7r+1TvVJjk
RtGCwG4qWTgUIDiiy3vdjgYa0hS6YEhiwcGucLiO7MsU5VjB89aS5iDg8nCjRXra
IbQRR3wLWLn+82W/rLt3DXv+TIZl5o9II+MC5x3Mr/KALbFAFFjOry+3UNnf+UMs
XdoIOv8nVVdcVaWk9bbigKIMovc0LV7h8CPh2ovND7eZBY4YfqpWPwxrwJYgzbbo
VupEcozvp83oKE49gN9+0iZSpLtDBkHf14Nze9ad8RrUKdU3YASzInADBZhkjQGa
CK6ygR9GSgvkn9ePWByS3v7Ds/wiyLYI4xM2DP9bPn6JNxWWWfq72qHypByeMkt3
OW5y+qbPS23Fc1ZbteE5Y4TcTHjzAM42h4PP5HbXsuQIvK8cn4z+urOizRXgd+H9
ob/kF2hLqQXssc1Nthnt
=4PPn
-----END PGP SIGNATURE-----

--CUFRbl9plnVqmeZZ--
