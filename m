Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaAPUrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 15:47:03 -0500
Received: from ozlabs.org ([203.10.76.45]:60719 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaAPUqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 15:46:37 -0500
Date: Fri, 17 Jan 2014 07:46:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
In-Reply-To: <20140116121955.GQ31570@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	<20140116121955.GQ31570@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_07_46_28_+1100_Ds4ZGWHAk=lCeVXf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_07_46_28_+1100_Ds4ZGWHAk=lCeVXf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Thu, 16 Jan 2014 13:19:55 +0100 Peter Zijlstra <peterz@infradead.org> wr=
ote:
>
> I think the below ought to work

To be clear, all you did was replace the body of mwait_idle() with

	mwait_idle_with_hints(0, 0);

(and the comment above it)?  I need to apply in incremental patch in the
merge commit.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Jan_2014_07_46_28_+1100_Ds4ZGWHAk=lCeVXf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2EUoAAoJEMDTa8Ir7ZwV5fUP/jfd/lVky9my2PddEGkcvQsn
Jio9vlGNlwlB3caOmStVQ8jcboBf6XEELKROsEJ82t0ATGPo2D/1Yfkm4nQRl/q3
lE1430vquUY0gAiIAIKcX74p2MKw4E4QoC9MrMUELSAbebvGpRg/qHCbHfOhe6Nb
nHLOFg8FR70x7NHNtD4+Sg+VAhpgYIqfqbvKX5UrUJwKVod5YoXoYIyvOiCdCMDB
euquVUs27+H3m39OkNFOcv8CcLYQjLOiwGCYcSk3H02ppx01/iZ9bJvJTfU/FkAl
9gV6Kb4JYlxzNevigM94Muowx/Mo94eDufHhkR5dH5notqz5G5sJlbQR0QKviaOz
2INXfjvdNCO0MLFU1rU1y+mPrEn1B1RWnuB20shIGum0oj9HRv4NkE3iqLlD2IN0
hUVdQMZ3EuMo6AX364d9AxYRRD86JNiSgeK4M1/M/5I3mnFSIwy54GekaijlGis1
ayAz5w4jeMCcKx8QfG+xe4iBmNg+pIrJkcR4/otQtdmVwpvDnyBrykn5S7GdF+f4
OYXbztNu21z6wgl0UtZVyfb6YxWLJfp6f1QoypBn5+ssVXFQuhgunhGjNEU8b21b
YaoufsNu0yjSrV35uEW+dp90vrhNeqggBiFRBtl0oZLOxHbNm6dcniamGNVyNNKN
zRHGpaxpN3hFZw7nLEXc
=f9/h
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_07_46_28_+1100_Ds4ZGWHAk=lCeVXf--
