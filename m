Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaFEN0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:26:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:52310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaFEN0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:26:41 -0400
Date: Thu, 5 Jun 2014 15:26:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
Message-ID: <20140605132639.GK6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-10-git-send-email-eranian@google.com>
 <CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
 <CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
 <CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
 <CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
 <CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
 <20140605125022.GF6758@twins.programming.kicks-ass.net>
 <CABPqkBQMi5NoL1EFB8ajopF8QbF3kiFgk6NkSkaqzruVaEQJOQ@mail.gmail.com>
 <20140605125929.GH6758@twins.programming.kicks-ass.net>
 <CABPqkBQq1ifgVEK-kdnyMRz5bmMPgfkoZ7VyP=2U37cUUDMvog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VJJoKLVEFXdmHQwR"
Content-Disposition: inline
In-Reply-To: <CABPqkBQq1ifgVEK-kdnyMRz5bmMPgfkoZ7VyP=2U37cUUDMvog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VJJoKLVEFXdmHQwR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 03:16:47PM +0200, Stephane Eranian wrote:
> > Pretty much anything !early_initcall() is ran after SMP bringup iirc.
>=20
> Ok, we can try this. Need to check the impact on NMI watchdog if
> already active.

Right, we could provide an interface to stop and restart the watchdog so
that the PMU is quiescent when we flip this switch, if required.=20

--VJJoKLVEFXdmHQwR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkHAPAAoJEHZH4aRLwOS65dkQAI5KN6WtyeDXVuo47ztCN7zu
7DyIKbZGxSu0lhWPVl5UKVctW2FggkKPRy2NqyKDeAPBdbeUozN1Gi9NeziPkSZ7
463mYK5uYb/46jUSn0ke0XfDpySNRy8nQOv0xwuvVn7ZIDq0Gk/Xg3e/YVXmR/sA
JhbTjGRI/rwY305qs4Q7vE3mcFXbyKUn7wNAu6M11ETfK4vsyoXKcqh8ZjuQA/3d
elIgYLgMNMFkfge6YjCtrINMtJnJG093P0AYfPQDPt9Nc6xD91yWXBSzrbANU/iU
rXAksor9uwn4Ag/JV4meeBuub6kJbIV77IszrysGHAzb4/t4rM6F7ojWTlBIUPV7
T4grwWCf6a0SB4DuFkf1AvJEgvoxi1uXATxIRij/SseMML1zyJZqQ8P6gdJl5NsC
upHbanyvM9TkUwVBFSDHWGou8Hh6xVzIFu8jeoUms52A3xi9yRWFUnzlrtCljLnZ
XGl7r+Nje19keIEDO5bFujapRbWssRfHtpraYvc3oBhNPCqJnPLQjg5KA+u8ezfM
VBCzqzbHMa81wl+3PjExZ+gLdslciA0DahSmK07ACNWvXKoxTRGaKVdhyoW+a/9Y
cR7kH125Z5LQ+Vek93LRcdaV0X0zf7egdAPopH2GvpyWqYgP6P3rDIe9V6zqKNU3
wx9zeP7PFBkjMQ7gPqzY
=Q3Cf
-----END PGP SIGNATURE-----

--VJJoKLVEFXdmHQwR--
