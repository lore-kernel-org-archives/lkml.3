Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3JOGru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:47:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46177 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab3JOGrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:47:48 -0400
Message-ID: <525CE50F.9090801@ti.com>
Date: Tue, 15 Oct 2013 09:47:43 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Archit Taneja <archit@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the omap_dss2 tree
References: <1381762088-18880-1-git-send-email-treding@nvidia.com> <1381762088-18880-6-git-send-email-treding@nvidia.com>
In-Reply-To: <1381762088-18880-6-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="JdbFkOcNKhpge568KjjJWLGoetws60BHh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JdbFkOcNKhpge568KjjJWLGoetws60BHh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 14/10/13 17:48, Thierry Reding wrote:
> Today's linux-next merge of the omap_dss2 tree got conflicts in
>=20
> 	drivers/video/omap2/dss/hdmi4_core.c
> 	drivers/video/omap2/dss/hdmi4_core.h
>=20
> caused by commits ef26958 (omapdss: HDMI: Rename hdmi driver files to n=
icer
> names) and a few others that I didn't quite track down. But given that =
the
> diff of the merge commit is empty I guess everything's well.

Jean-Christophe has slightly different versions of my patches in his
fbdev for-next branch, so they conflict with my updated versions.

Jean-Christophe, I expected this to happen with the current way of you
having a copy of my for-next branch in yours. Can I now take your
atmel_lcdfb patches to my for-next, and you'll remove all patches from
your for-next?

 Tomi



--JdbFkOcNKhpge568KjjJWLGoetws60BHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSXOUPAAoJEPo9qoy8lh717SEQAJNfzfsHVnodHCyrrPc8Q+/r
7Rr+OtJ4kio5x7gcZZ851Lon1Oe42IgAv95b+JZfPG2cHUntK7am1VCnADscUf0y
mJnhMgk6q+jW38B9ESwn8av8n5bkcYpj7ZlLn9sqKSDO/LEMNpOlFnVjGGrJQGxZ
L+V1lTVFBmQoxg42tvZmlXVRb5umgW7COSrOnozK06jVNdGEO996fBJbUJSZbW/O
87etmLvkgE3B5z3ZspkWTtQk1JpQXGZaG/1zm+ER3G7tVOPEGhW5hrouuvSDRcgx
Hwrvr7yL626gJYTqh/rqUNB2MLMWDCmUcv9kFsS/5vFbkHFhNrRB11JVh1/CC+qd
UrWB53TA7fYmgqiJP/4fKmNxkZ0aCYfkVPF8722iua4NCxdeTAXJ/n12qWNOMKu+
kp6LCQ4QB1ZL2TEOvKtxeIHygiKq1jmPpdD8VDB3cGQ1zfpTEjpLC0eNOe+FxFtO
VHAhx1h8LeCrrQvN52R13SudGgcbJgvg/AuJO6HD0oXkaPDjqcVISF/IE2N0J6g5
eFYbNQ2l73T0P94r3RQu7bjZGdwo9bn3MjURiEAKSOfhXTg3Da0G/xD95ZqYd3Ie
TD3Xo4h8YPvg5f+juUORJuJK5MSYnw5GQI4NjTWo9skGYXvkjxi8GxhQiC6k822J
c4dg0wc8tJNExrXmrW1x
=P07Q
-----END PGP SIGNATURE-----

--JdbFkOcNKhpge568KjjJWLGoetws60BHh--
