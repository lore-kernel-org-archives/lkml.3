Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3AJXex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:34:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47116 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3AJXev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:34:51 -0500
Date: Fri, 11 Jan 2013 10:34:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3 00/44] Meta Linux Kernel Port
Message-Id: <20130111103442.b80ddbfb11ef322ed28ca3b3@canb.auug.org.au>
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_10_34_42_+1100_jZOfEz9sQNovqui3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_10_34_42_+1100_jZOfEz9sQNovqui3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 10 Jan 2013 15:30:28 +0000 James Hogan <james.hogan@imgtec.com> wro=
te:
>
> This patchset adds core architecture support to Linux for Imagination's
> Meta ATP (Meta 1) and HTP (Meta 2) processor cores. Most of the feedback
> from the RFC and v2 patchsets has now been addressed. All further
> feedback is most welcome.
>=20
> The patches are based on next-20130110, and can also be found in the
> following git tree:
>   git://github.com/jahogan/metag-linux.git metag-core

You really should not base development work on linux-next and before I
can include it there you will need to rebase it onto Linus' tree (or some
other tree that does not rebase).  Its OK to test by doing a merge with
linux-next ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_Jan_2013_10_34_42_+1100_jZOfEz9sQNovqui3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ71ASAAoJEECxmPOUX5FEXV4P/1fqgXacWn4AqnQdk614ZohT
wv7SIMZm/Z0x49c+j7+KEH+9Lxog8UQXlFs2YbTKdEh4PYFcNutU/INk5AEUiPrv
6LyI4992gzeL0xC7X0dNGnq9PW+B7hSmGuVcEwRpKzzu9lLMbRsBCYZa1iX+rsif
chuaz40lVam9+MgoZ724C1IZjSjwzjQvD8UcFEARtcXjaBaUGI9VVpO7lAD1/g7y
qBd4NhfVkSklRk3dDcLigjm51q7z/Tp4rO6WJ06R+UBDcy1bYXotb5AhsuPAIrtt
7pZ2E+JVmrmlGrLTZisy4WcOgv4kpztIH57FV4oyzxNAUeIn4ns46ftTvpq/jr2l
DqY53KyryFcTljOpoHRumTsKkWKq+90tQ8bIqk/lXzcymqpXlo5h8ltvt2cs3uR9
db2WXcIpLLDP+DiV+MjyA1QWHXV5bw/Uxot1gKr4IznVxwOj7V6T4UROK25D2U0F
ppUR9Skbc2CPw7XyoUCKIfEm1YQB8khwJ6w/+YVDa+cWgBDCVVlCFXHgiz90n0xV
M73WX5SvjLZPPCbibobGMpAvzeD/K5voD7PHrniAF3A5PFJIPYhaBGEAjnNyGoZf
sswe/qXbVtXWAY14B1Ae80vIRDQsDrYeE++KbgpTK1rlwcpPuK/pjHpvXx2CIhCk
MQ1lSZhkmj9S2IaRuBn0
=t8+t
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_10_34_42_+1100_jZOfEz9sQNovqui3--
