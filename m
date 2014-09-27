Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaI0KLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 06:11:39 -0400
Received: from ozlabs.org ([103.22.144.67]:33875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaI0KLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 06:11:37 -0400
Date: Sat, 27 Sep 2014 20:11:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the tip tree with the audit tree
Message-ID: <20140927201128.3f6a34c7@canb.auug.org.au>
In-Reply-To: <CALCETrUFHZuhG5qHaJ3yi8P06hLYSo+76y5ZcqXwHahQSUZt-A@mail.gmail.com>
References: <20140924154737.50db90eb@canb.auug.org.au>
	<CALCETrUFHZuhG5qHaJ3yi8P06hLYSo+76y5ZcqXwHahQSUZt-A@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/j.uvljDDy5CNJzrWctUrHHN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/j.uvljDDy5CNJzrWctUrHHN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Fri, 26 Sep 2014 11:02:27 -0700 Andy Lutomirski <luto@amacapital.net> wr=
ote:
>
> I don't think that more cleanup is possible after all.
> do_audit_syscall_entry may not need to pass the arch parameter to the
> audit code, but it still needs it to choose the set of registers to
> use.

Yes, indeed, I did not look clearly enough :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/j.uvljDDy5CNJzrWctUrHHN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJo1XAAoJEMDTa8Ir7ZwVviEQAIvuCHu56Nj3gjRFO4Ya1m4P
EH2JZ54fJswS9s5DUx24xNkml42ByMqZxVSib1ebfNzgSm8WEFznyBxnLb1ZNPOn
brzljuJvDML8dD+x6s5MS/2LN/aMYzEuAGMosYrP5Y7GmJ60SUDFcmR1g0OLRStX
hj9+vvsrA3sWLNpaIlKQpcagxH7LvZTvDfZRluWWRFVCDyUa2GMkDDSRTJpo4drc
5h3NOZ9XlfVyPqo2o18rxGRiTD4jbVSJjmvQEU/nTiccPraUazwTfE1z2Kf6erU7
2RVWn9lPL0TN+WC7Es+PA0RwWXyVP+8nvIDtXWsmJ4eoGDHSLqovNtkn5AtkRqwC
qXVSytcOZeSIN7sbONrbjfTYCUwhQb3bQORgJWrK2BrlYnQJ7eOGGYJNrg+S3J0U
fWP58be2mj6NgdYLtoLX3ov5j2DAuNalDGZ7cAgDfcW4EGtUW9EsBGLyrqaKY8an
iEv+fMQXoxT17MPG3Zpu9sBFH8F6zLTqDlXZJgcFkLL1nrHfuqMQhm0CYfs9sh1L
S1PQYIs3/VpMvFetXi2xKEY8HUGM9rPVOUyvtUIXQGatn3AqLNHwikdLuukhTLYD
2l/n6qDgihK7C0PZ1Qx2SjrFoqCQxxi7g/UOCYWvf9/ZsFCW7qebcBf+qFSRZLOO
fdKmsZr+AqmxkBFM8tFl
=tiMg
-----END PGP SIGNATURE-----

--Sig_/j.uvljDDy5CNJzrWctUrHHN--
