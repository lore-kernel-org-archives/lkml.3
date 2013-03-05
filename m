Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab3CEVjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:39:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40628 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3CEVjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:39:07 -0500
Date: Wed, 6 Mar 2013 08:38:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failure to fetch the watchdog tree
Message-Id: <20130306083856.5ba4d203ec0c7320af862047@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Mar_2013_08_38_56_+1100_4OxX=1H35iyM5X4y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Mar_2013_08_38_56_+1100_4OxX=1H35iyM5X4y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Fetching the watchdog tree produces this message:

fatal: unable to connect to www.linux-watchdog.org:
www.linux-watchdog.org[0: 83.149.101.17]: errno=3DConnection refused

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Mar_2013_08_38_56_+1100_4OxX=1H35iyM5X4y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRNmXwAAoJEECxmPOUX5FEyGMP/Ry3YOU2lAheXXik+LLBycUm
IbTk8ieBirf/VJvFCHEjbAfUJLUx894ElW1ncd6lmB4E2nUiTmsRilzU3ENcb3TM
Eh4v+JrmrtpDroESiXlvpLiG0QgNJxl+sg6CNlFCi+aNLplD8Ycp17Yaibeyhoik
W5f8bWXw23tZPLEGmPH1+8rbzPMC6ztvLAg0b4EN9dpwOnPYXfEiF6wm3JQph0v4
CrB+igMJ5wO7sPxBkxcSEvVuLmDfXjttKBkdPXiPoTkPwNigwF45JdFYdqjdt6xv
V+9EvATle8yY7OnwlLXhtH+ImFzM9h6kK8i/LWKfbHsJ4BjEmwdslxz9+dw6y0JY
UvBxjFJoDnwFEdKVfOmKLDtgCPBmux8FbzicgwVQu7LSnA48+qo22/RfOk6fD23n
A4ysEFlkrg46PWdjKo6oXDS3j23KoqWpzBGl/elrvvWzKjb8SrX+LEtp5NaABUXD
/JvENGLH7bf7Gc4vveNUGw0HReU0nCa3HMqp8qpv/9IEDC4zpurFlWlV3bvnt2xp
aUuxNlaU3+NWo9MtfND7E5xtfDA1hCun/aNK6DVVctQUzfYBQnG+IUJd51OT/GPQ
MSNVZG46MxuT9NVeF3mYtamb4eohMn16pf9S9GkEMP+1omXHrzKwPmBKqnYij3q7
ma32EPojY1J34u0LM2H7
=rG+e
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Mar_2013_08_38_56_+1100_4OxX=1H35iyM5X4y--
