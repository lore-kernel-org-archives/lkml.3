Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbbAVFOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:14:19 -0500
Received: from ozlabs.org ([103.22.144.67]:36637 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbbAVFOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:14:08 -0500
Date: Thu, 22 Jan 2015 16:14:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Michal Hocko <mhocko@suse.cz>,
        Krzysztof =?UTF-8?B?S296xYJvd3NraQ==?= <k.kozlowski.k@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm:
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch is
 causing preemptible splats
Message-ID: <20150122161402.3330eabf@canb.auug.org.au>
In-Reply-To: <20150121193411.44f96b6c.akpm@linux-foundation.org>
References: <20150121132308.GB23700@dhcp22.suse.cz>
	<CAJKOXPdgSsd8cr7ctKOGCwFTRMxcq71k7Pb5mQgYy--tGW8+_w@mail.gmail.com>
	<20150121141138.GC23700@dhcp22.suse.cz>
	<20150121142107.e26d5ebf3340aa91759fef1f@linux-foundation.org>
	<20150122015123.GB21444@js1304-P5Q-DELUXE>
	<20150121193411.44f96b6c.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8ef9APx7A7P0hP8pS_M7BQk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8ef9APx7A7P0hP8pS_M7BQk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 21 Jan 2015 19:34:11 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 22 Jan 2015 10:51:23 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> w=
rote:
>=20
> > > The most recent -mmotm was a bit of a trainwreck.  I'm scrambling to
> > > get the holes plugged so I can get another mmotm out today.
> >=20
> > Another mmotm will fix many issues from me. :/
>=20
> I hit a wont-boot-cant-find-init in linux-next so I get to spend
> tomorrow bisecting that :(

There has been a long discussion about something like that already.
Subject "Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to
mount root fs"

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/8ef9APx7A7P0hP8pS_M7BQk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwIcfAAoJEMDTa8Ir7ZwVIuEP/AiVbPc0w8Cw+T4e6ITcRnpW
xz8PWI1WKF/C1GPaLjydmrED3rlgtHcqNZwtfzolblFYnZ9Qm6Oin2YCIl+XO9++
4c55oRU/3bKzVs6f9qcq+xykXE/tWPwjvT2Rneujp7wWE8OBmtot4lW6h6g3F/do
hFrhYnYODZ4prE7E2LFlt5Tk5VS+OTzPrUTHTYeWE3jhtYD4EymEwJ9wX4ytep3y
dNVqxDKuRYaeXiiMhTue5fEta/buPKoYexb8hgnhDnZT/Vr9iULUzJtikOTo3Obc
AZzSLJvam4GD5MzeUzRcGDj8NDeS4JsRb4fx308d5ClNAEs1IMkOqC0TFVJYH8f5
XalwabjFGSnqXkJtGsQr9zacapgMlyp6LQ3xCt5HCSift1XnXywi2V2PMGsBbxtk
ItBDCJIZYsba6xM9mtex7/Yyuf35fGVZX1GEdnz+ILDFx7inYP0kk3UeMdVnQWSo
wbgzfHaga0H2Rr4pXMPwLyLlS/93CFzN8UQFcQQkpO/FxiOOTs6EMlytp9y+nsQ2
UBbxcS4kKgvUkiyj75noq8n/31PTNxXPT20IIcAVXSwYp21C5KvpkdDr54pCMOva
z4ASowq3JivKgYZNHuV74vYLhrAnfmLH2oxhdqRZl5kpGJBdX4qgkJPxZcv1jQWC
Gk95VVnIpXgl4DvYpZOr
=Saoc
-----END PGP SIGNATURE-----

--Sig_/8ef9APx7A7P0hP8pS_M7BQk--
