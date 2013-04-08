Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936063Ab3DHU0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935781Ab3DHU0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:26:08 -0400
Date: Mon, 8 Apr 2013 15:25:58 -0500
From: Clark Williams <williams@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8.4-rt2
Message-ID: <20130408152558.627dc8b1@riff.lan>
In-Reply-To: <20130408183012.GA5778@linutronix.de>
References: <20130326201722.GA14220@linutronix.de>
	<CAP=VYLoXfECaSBuvYdZ3qbsnR9QMYpoRnKGZdY=P6zS_TYOcCA@mail.gmail.com>
	<20130408183012.GA5778@linutronix.de>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XMfRqybk0s1cRRQN_SpW_=s"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XMfRqybk0s1cRRQN_SpW_=s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Apr 2013 20:30:12 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> * Paul Gortmaker | 2013-04-05 19:35:51 [-0400]:
>=20
> >Thanks for the work in putting this together.  Just a heads up that the
> >split queue fails on a patch with no author/date/subject as follows:
> >
> >[...]
> >git am of percpu-rwsem-compilefix.patch failed.
> >
> >This "treercu-use-simple-waitqueue.patch" has the exact same problem.
> >
> >Note that I'm using git directly, and not quilt -- which is more
> >strict in what it will accept, hence it catches these kinds of things.
>=20
> I just fixed up those two. "git quiltimport" works now.
>

Thanks Sebastian.=20

BTW I imported -rt onto v3.8.6 with no hiccups from 'git quiltimport'
other than what you just fixed. Not much runtime on it  but it booted
without complaint and ran just fine until I tried a suspend/resume.=20

Resume seems to be borken on all the 3.8-rt kernels so far.

Clark

--Sig_/XMfRqybk0s1cRRQN_SpW_=s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFjJ9oACgkQHyuj/+TTEp3UZgCfeZIWeI7rNn1+sgwWprTxewmV
0YMAoI06XnwFXZqqGBCgbgytydOrN9HI
=1CGe
-----END PGP SIGNATURE-----

--Sig_/XMfRqybk0s1cRRQN_SpW_=s--
