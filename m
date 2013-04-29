Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3D2VTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:19:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402Ab3D2VTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:19:40 -0400
Date: Mon, 29 Apr 2013 16:19:25 -0500
From: Clark Williams <williams@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org
Subject: Re: [ANNOUNCE] 3.8.10-rt6
Message-ID: <20130429161925.2a6ea78a@riff.lan>
In-Reply-To: <20130429201202.GB7979@linutronix.de>
References: <20130429201202.GB7979@linutronix.de>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nMflnjYfLYTfPEamWm6SSGi"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nMflnjYfLYTfPEamWm6SSGi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Apr 2013 22:12:02 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>     - suspend / resume seems to program program the timer wrong and wait
>       ages until it continues.
>=20

It has to be something we're doing when we apply RT to v3.8.x, since
v3.8.x suspends/resumes with no issues and I was able to suspend and
resume fine with the 3.6-rt series.=20

I'm looking at a git diff between 3.6.11-rt30 and 3.8.9-rt4,
specifically in kernel/time* and arch/x86/kernel but so far I'm not
seeing much that's RT specific.

Clark

--Sig_/nMflnjYfLYTfPEamWm6SSGi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlF+4+IACgkQHyuj/+TTEp2P/QCgo0U/kApDd5rhtIW64GqaeTBG
bnwAmwVQP2HllnguXSkOCymbcHXN89aS
=MFKP
-----END PGP SIGNATURE-----

--Sig_/nMflnjYfLYTfPEamWm6SSGi--
