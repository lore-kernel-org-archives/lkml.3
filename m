Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbaLBPnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:43:11 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54011 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaLBPnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:43:09 -0500
Message-ID: <547DDE00.8090906@aurabindo.in>
Date: Tue, 02 Dec 2014 21:12:56 +0530
From: Jay Aurabind <mail@aurabindo.in>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915 Trouble with minimum brightness
References: <5478C9AA.2010600@aurabindo.in> <87k32bbtmo.fsf@intel.com> <547C5890.2020306@aurabindo.in> <87bnnnbm55.fsf@intel.com>
In-Reply-To: <87bnnnbm55.fsf@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="atRxxkGUXASqKQ0swte81lUcwfAOsBbBs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--atRxxkGUXASqKQ0swte81lUcwfAOsBbBs
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/01/2014 05:46 PM, Jani Nikula wrote:
> On Mon, 01 Dec 2014, Jay Aurabind <mail@aurabindo.in> wrote:
>>> Please file a new bug at [1], reference this mail, and attach
>>> /sys/kernel/debug/dri/0/i915_opregion.
>>
>> Thank you for the response. But the file you mentioned to attach seems=
 to be
>> a binary file, because I'm getting lot of junk characters. Is this nor=
mal ?
>=20
> Yes, it's binary.
>=20
> BR,
> Jani.
>=20
Hello Jani,

I have filed a bug report=20

https://bugs.freedesktop.org/show_bug.cgi?id=3D86936

--
Thanks and Regards,
Aurabindo J


--atRxxkGUXASqKQ0swte81lUcwfAOsBbBs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlR93gYACgkQq5pl9aLRKAXNxQEAig7MAwDb+tvebQRLKZGARKOM
mEHA36R6ORGprE5yBaYA/2CmEhIZM7Plvn8/UVD+Z5eLDor4KH39dJ47VVfhSAoi
=ntrn
-----END PGP SIGNATURE-----

--atRxxkGUXASqKQ0swte81lUcwfAOsBbBs--
