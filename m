Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbbAWNqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:46:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbbAWNp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:45:58 -0500
Message-ID: <54C25083.7020603@redhat.com>
Date: Fri, 23 Jan 2015 14:45:39 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 2/2] zram: protect zram->stat race with init_lock
References: <1421992707-32658-1-git-send-email-minchan@kernel.org> <1421992707-32658-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1421992707-32658-2-git-send-email-minchan@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iBVRAcOvgeqUu7hXE6xEwavCrhj59baHX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iBVRAcOvgeqUu7hXE6xEwavCrhj59baHX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/23/2015 06:58 AM, Minchan Kim wrote:
> The zram->stat handling should be procted by init_lock.
> Otherwise, user could see stale value from the stat.
>=20
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Jerome Marchand <jmarchan@redhat.com>



--iBVRAcOvgeqUu7hXE6xEwavCrhj59baHX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUwlCDAAoJEHTzHJCtsuoCdIcIAJnBlfB3Mgo+kARUZ/tFtg+T
2MsDY32R0j59OXXLyo4B+fD0ge3WV0W8sX5JFjYmMAnI0bLBwo9RSWKyneLN22Ac
4zS2cVwSUCc2/3SB0v9RYWW/FLQ7XteXcqCXS7R99j0yjlQWZ+SJ311JsWnmMRk0
i1zFyMCNbM08/BFoekU7zUnuGZzaoTAr11rzm/7wbRS18ghJMMAr8kNBqwTLJ7te
+xCVafwPIlN17IwrCq2rJ3pRmdIizO0bYt7rMujn6ytfVLtN3Rgjqc2HTPOQuJdD
bXCeOLCaXh55zqC1VbmnHNkTY0TkDLXNo+eh88Lib5SQ2q7EwUAqVpxQQGAFazA=
=N7xA
-----END PGP SIGNATURE-----

--iBVRAcOvgeqUu7hXE6xEwavCrhj59baHX--
