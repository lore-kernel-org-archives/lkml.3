Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab3CVFB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 01:01:28 -0400
Received: from ozlabs.org ([203.10.76.45]:40210 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab3CVFB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 01:01:27 -0400
Date: Fri, 22 Mar 2013 16:01:19 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 02/34] arch: Consolidate tsk_is_polling()
Message-ID: <20130322050118.GA31022@thor.bakeyournoodle.com>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Magnus Damm <magnus.damm@gmail.com>
References: <20130321214930.752934102@linutronix.de>
 <20130321215233.446034505@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20130321215233.446034505@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2013 at 09:52:57PM -0000, Thomas Gleixner wrote:

> Index: linux-2.6/arch/powerpc/include/asm/thread_info.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/powerpc/include/asm/thread_info.h
> +++ linux-2.6/arch/powerpc/include/asm/thread_info.h
> @@ -182,10 +182,6 @@ static inline bool test_thread_local_fla
>  #define is_32bit_task()	(1)
>  #endif
> =20
> -#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
> -
> -#endif	/* !__ASSEMBLY__ */
> -

I think taking out this #endif is wrong.  probably wrong in the other
arches as well.
=20

Yours Tony

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBCAAGBQJRS+WdAAoJEEsCiJRY75GKaV8P/29Beq3fXuM7BW5Xnds0Qksg
NC2pSP1IejBwjWfiGoWVeSuorffFtu/jy2n5rauGozox1nuU6TdZrV9wN0Z6H/Xc
pdSgk17vBDpJxRpyF8tWR5UA+7gMbf+fQ+0n/JdureMU1PyD+lF0IysxhMraXGmi
FtOarVfuewnz9WFhl7fokJNB6SkDxQV3AUFkhdpv9ErQtE9szTueFlXAjZF1+07T
CqjnU8DiHWc9wkKPoOMoAucuucOh4/kVS2RF4iNV0dYq9zem6k9/3NxPEqVLbmv/
C0/bq77dAwvKyJq+wA8C4Fgf5WXdizvyckoIHGhN8nDIiEIUQBAQDG41SddpN4hS
5lCFDYMe1fq+9N7AV/C+CDoK/HGtK/RXQdPZuRnYI//KjEWBh5cWfubj97zC2OIc
wr68tQZ6t863DvlVgTrPZyhFJVBZ7gJfJY3jYee0Ar//lByinMGsSDbMpgJ25U0B
l5K0JD9yxE/qGjT595aIMbOdiiN9e/j30HBneij1JRFYeRiPe4l7KBUar1kuUcR8
puiQLveAZj388fdlMIEoVPcrnJUj0CAnUkGxWb2em8KE5P+ncMfLzEKjRkLv0+Bh
B0/YRzWqTiW/z0GWuv2rukkYDpaZDgsuNG2XyQxDCUuYducv0Qm1dwUsRJ+It4lY
WZiu2GFn2V11gnAR14zD
=LLmO
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
