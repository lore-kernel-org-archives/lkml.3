Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3F0AxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:53:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48446 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3F0AxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:53:15 -0400
Date: Thu, 27 Jun 2013 10:53:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-mpidr tree with the arm
 tree
Message-Id: <20130627105301.c95d471912255190cbee6129@canb.auug.org.au>
In-Reply-To: <20130626085719.GA22333@e102568-lin.cambridge.arm.com>
References: <20130626110411.d1fe3913769385fa056010be@canb.auug.org.au>
	<20130626085719.GA22333@e102568-lin.cambridge.arm.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Jun_2013_10_53_01_+1000_I3bOAGSTU_ysgkKK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Jun_2013_10_53_01_+1000_I3bOAGSTU_ysgkKK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lorenzo,

On Wed, 26 Jun 2013 09:57:20 +0100 Lorenzo Pieralisi <lorenzo.pieralisi@arm=
.com> wrote:
>
> No, arm-mpidr can be dropped from -next now that those patches, as you
> correctly mentioned, are queued through the arm tree.

Thanks, done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Jun_2013_10_53_01_+1000_I3bOAGSTU_ysgkKK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRy4zwAAoJEECxmPOUX5FEOS0P/3ZNQx/chl0IopiJxkLsmfXl
g2zPBNKB1CpnQQWqwB0kSDKT40FfL4Jb1dCemzXq0VCjmLW7SntJ+JMH/8kqLqdZ
2QgSfLTTkqCTL3VMyHykVDBPQyJIn3onqe5xl0/qmkbFiBUKCnaHpVQFx/mOvzgp
mlLyT/ui8hfueHk3QxftHxwaKgHZYDDbeaWDjiEYdCbFaA2hCmu/7QTW79S5rVfR
uJo+9ysrSjKVGqg4xeZna9uNrE5dGLSg/5+m+7/lB7SJANjwM83UG3IkajoyqBJi
DhPPMdH4VI5pmtiMJwuZYf0pYTj2trkTmd0EDnUMuhtiORSTbMc6r6JqafvoNfWg
xjkq0uBG3UF1wSVWxKl2STWP8d6UjxzA0g/4JRhDIIPtNlN/dzKQCzkLl7BZUoo9
GLW0vgjsvF0jbMRzQqZ3AF30s0xHMPoYl4AuaDUzoRajtZTm2iPZObFagC/3GqLU
+YpPMcj8I52YAF/iJgujZ39ZiwIkMo8Dy+noDNh03MV1M6ulqZeTVG7z1GzDKnGI
RL5Kh51jmxt5ZGguy2rU/4IONjv79eprmX5X9nEerYDYSKgMNwcqX4MTH52cEJ5P
u/YYp0cDlVBYFUmMAIWyEo6SlJU9cf7+s0c+Uer7zy5Er/8am+Vii2jGNT7sxGXP
ddfMA+nlpJ1G1Z9lhiAw
=XXmz
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Jun_2013_10_53_01_+1000_I3bOAGSTU_ysgkKK--
