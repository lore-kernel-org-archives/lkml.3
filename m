Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3H2JX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:23:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56454 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3H2JX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:23:27 -0400
Date: Thu, 29 Aug 2013 19:23:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the selinux tree
Message-Id: <20130829192318.94d3e9b1c8d4f6f05c385e24@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_19_23_18_+1000_+.wESdYhrRxZgeVa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_19_23_18_+1000_+.wESdYhrRxZgeVa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

I have dropped the patch "revert "SELinux: do not handle seclabel as a
special flag"" from the akpm tree as the patch that it reverted was
dropped form the selinux tree (along with everything else in that tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Aug_2013_19_23_18_+1000_+.wESdYhrRxZgeVa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHxMKAAoJEECxmPOUX5FEx2MQAInH26bdyA33e/0QlkICdmnk
xCZdhrZ66BeMp82o0sYYeJ8hYLQ6bmDJGRuSPF5RxRVC1mZtml4LiqhTPv172yFM
1yHjPhCXJzUDfW+70HlR2GdHUVCpxrE+dke3PgcJhzjwtxgsTy14bFdiRIAsz1cp
nopgQcz35Q2H64N4cPQU5D76VxRh7YIm19uwe68rC7WToQMNh6jPTvKRrh0rl4sj
52hxUdJbxqgjBLUuTh+Si6WaCtpUE65tR2SbMfk/Pdrh6CWauNfSb6YTHb97KbL+
LwkTw9PzHN0E08M9Lb2mIUa9O8JR4fSTQDTfovujqLUvA4RcBKEp7CP3E9zhRto3
eVM2kj1Ukd0EeZc2lFeWDIkoZ0AMr6qDNl8twaU3wpbShJXw89HMZEj97js90tv0
YIyZM5w++vxPU4Z5ofGo4t7/6HKYv5jm0uF+djlfKGSNl8KR1x2kjKCCB1ZmdvPZ
n2Usvt6k9nvjeMMjq4qdv3Qrm8CwzzDsJ1/w7/B8vtDuEnzaQgY66iI3Qg8n/rmw
I9aJdNf1cQKoIOLxgChl4qjbFXHWnJKUMNokoTHjUjqXl2o34oGJEdkM45b2Q6eI
p6o8qaSuhAqn+n8933TDfEQNlO8+0yFLOWceXvjvZz0gKr/KUJubhBS3CwryUur9
exjUJbAexKCTz7+QhqMU
=xAOZ
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_19_23_18_+1000_+.wESdYhrRxZgeVa--
