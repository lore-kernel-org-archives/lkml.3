Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3EHXsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:48:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40318 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3EHXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:47:52 -0400
Date: Thu, 9 May 2013 09:47:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Teigland <teigland@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for May 8 (dlm)
Message-Id: <20130509094745.049e46fff25f357e7eb50123@canb.auug.org.au>
In-Reply-To: <518A93BD.3020300@infradead.org>
References: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
	<518A93BD.3020300@infradead.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_May_2013_09_47_45_+1000_CVvkeDkwbZD5=G9Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_May_2013_09_47_45_+1000_CVvkeDkwbZD5=G9Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just forwarding to David ...]

On Wed, 08 May 2013 11:04:45 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on x86_64:
>=20
> when CONFIG_GFS2_FS_LOCKING_DLM=3Dy and CONFIG_DLM=3Dm:
>=20
> fs/built-in.o: In function `gfs2_lock':
> file.c:(.text+0xa512c): undefined reference to `dlm_posix_get'
> file.c:(.text+0xa5140): undefined reference to `dlm_posix_unlock'
> file.c:(.text+0xa514a): undefined reference to `dlm_posix_lock'
> fs/built-in.o: In function `gdlm_cancel':
> lock_dlm.c:(.text+0xb3f57): undefined reference to `dlm_unlock'
> fs/built-in.o: In function `gdlm_unmount':
> lock_dlm.c:(.text+0xb40ff): undefined reference to `dlm_release_lockspace'
> fs/built-in.o: In function `sync_unlock.isra.4':
> lock_dlm.c:(.text+0xb420d): undefined reference to `dlm_unlock'
> fs/built-in.o: In function `sync_lock.isra.5':
> lock_dlm.c:(.text+0xb42d9): undefined reference to `dlm_lock'
> fs/built-in.o: In function `gdlm_put_lock':
> lock_dlm.c:(.text+0xb45e7): undefined reference to `dlm_unlock'
> fs/built-in.o: In function `gdlm_mount':
> lock_dlm.c:(.text+0xb4928): undefined reference to `dlm_new_lockspace'
> lock_dlm.c:(.text+0xb4c75): undefined reference to `dlm_release_lockspace'
> fs/built-in.o: In function `gdlm_lock':
> lock_dlm.c:(.text+0xb529f): undefined reference to `dlm_lock'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__9_May_2013_09_47_45_+1000_CVvkeDkwbZD5=G9Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRiuQhAAoJEECxmPOUX5FEz98P/2YGNmnmwmAx1aEorXAFPlX4
5srNezqIPSE8xj2ZWPT/EyLnWsj+axdSdrqgnjMgMuN2WiVx8rakmM628DmcTQXN
pknk53y2LBDUqHW3gesJC0c4FbGVjUsFDLxUlsngy0FPJqCCmM3o4eWdnreMyLTj
cfwt4UPc1ndnQru5mXYjdc2YdMbUIVl8E1m8Sb9TyYyVRmq4ufa/OSLtQLa/1eJZ
kjFbkEPRuslaqO4u3tyhoYQcDG3leE6WquwvXoMVAfGs7YQargdxlwVaXTbM3AP1
/cqxiMXQ2RR4G3Ogk1H9+6VEdE99Pgs4YEW8Dudfi1kXD7PJVRBrq0yFN5OjlHO+
RcaAdIHM7ehk7Rek4aOV953U3YtlZaUM55BroLpDdGEx46HYGOmx63pHZMWu8jMc
6OEICYAgxwro+iXjNxT6UpV0pAYf2OJqJlvoSJi07E93Dp3/aZ/5lFtP87C2Afnm
Zi4pUbaiJGR2YI6Ujm37rWuQ7ZQZD7GT8hNYT8nwdtjlpiaF5ZYemGELMkc7NTC8
J/o1JfXTcNjjLjDZ+IBV+uux5uW6mUqtgWR5tqL+FKqevCMgINoAm7c97VdcHBIx
hIbfhm/XlIwcfJJY8bezfmUkfp82hkOJZPDRZWmPv+VfDoVvnv5NaOoE0BbtaJaA
i5tQKqxx6EVlT3yLawL6
=IAV4
-----END PGP SIGNATURE-----

--Signature=_Thu__9_May_2013_09_47_45_+1000_CVvkeDkwbZD5=G9Z--
