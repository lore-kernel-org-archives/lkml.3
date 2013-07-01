Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3GAG6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 02:58:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57673 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3GAG6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:58:33 -0400
Date: Mon, 1 Jul 2013 16:58:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Lukas Czerner <lczerner@redhat.com>,
        Samuel Ortiz <samuel@sortiz.org>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Ralf Baechle <ralf@linux-mips.org>, Valdis.Kletnieks@vt.edu
Subject: Re: linux-next: Tree for Jun 28 [ BISECTED: rsyslog/imklog: High
 CPU usage ]
Message-Id: <20130701165818.8affb576b2a780f8ca497558@canb.auug.org.au>
In-Reply-To: <20130630181945.GA5171@redhat.com>
References: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com>
	<20130630181945.GA5171@redhat.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__1_Jul_2013_16_58_18_+1000_nSTkD7fV3EGZ600r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Jul_2013_16_58_18_+1000_nSTkD7fV3EGZ600r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oleg, Andrew,

On Sun, 30 Jun 2013 20:19:45 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> Andrew, please drop these
>=20
> 	wait-introduce-wait_event_commonwq-condition-state-timeout.patch
> 	wait-introduce-prepare_to_wait_event.patch
>=20
> patches again. I'll send v3 although it really looks like I should
> never try to touch wait.h.

I have dropped those two patches (and my fixup patch) from linux-next
today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__1_Jul_2013_16_58_18_+1000_nSTkD7fV3EGZ600r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR0SiOAAoJEECxmPOUX5FELkMP/RokGMf5P0Rc0TUsG7WopGPZ
y3mTFRYsuZuXMuHdAJ/IqZMjOisulQu73pFT+cntpbPkqExnhSGZURGLY6d3M56k
FIaOw/AHq3ajB2lzGZVLJUJLnmPExZAmWPbJBG+q3lGx5Lnlnrc9CMJKpgLZ0aNC
NR21paeMAZQrTd7YLf6j6/mT5Kj4DXjX/GQtUCtzTT55WK2UMmLdHR3GGBXRy/TR
oNaFtE3v52aRd9OXB7tQMuvOH+7I+xkI53MmFkS4E9XSieC5sis3XMlTLI/qj1et
JcOLXcXSSGjmud4LDbYU8o6PkfjGlxAG8bnmCb4d4f7Zfing4j2gN47HBKxlWYsx
e03ngrL4RbNZkbWvQ4bwgWeal64sffom+jY41Bp9RKwEfe6/ohtdWq8VJhBiJZdQ
uwLE9nXaoQ5R/5IOkGV3kQWSbrevfiPa0+i4Fh3u0lMJXWq2npr/jopCUv2VOsHb
tS8X3/KETDUM1ceGBUzUsDD4X9AMDvj/KZRqfQMYdCtdbsJq/MOYYHH6kG3F+3tg
RP3FNwPQJ9IqrWMD+e79pXvn+N2Cl9hBU33VOUuktchyAsiVf+2wSqCzqhFs03kQ
25o+mKYmU9MZPuNhrFw/P6frfRyciqNaiuh/bdp2ocJZhJMcAhYAErbGXAITbvY8
LUaE1oWUVj6HPNQinPMU
=RPZQ
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Jul_2013_16_58_18_+1000_nSTkD7fV3EGZ600r--
