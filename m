Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaBMCWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:22:31 -0500
Received: from ozlabs.org ([203.10.76.45]:47894 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaBMCWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:22:30 -0500
Date: Thu, 13 Feb 2014 13:22:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20140213132224.af134bf1669a3713cce636a5@canb.auug.org.au>
In-Reply-To: <20140213131923.4a0b79959e0b27399c021aa7@canb.auug.org.au>
References: <20140213131923.4a0b79959e0b27399c021aa7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Feb_2014_13_22_24_+1100_Ukvw2TKX7fQSjt35"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Feb_2014_13_22_24_+1100_Ukvw2TKX7fQSjt35
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Thu, 13 Feb 2014 13:19:23 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I added this merge fix patch and can carry it as necessary (John, if you
> back merge v3.14-rc1, you should include this patch in the merge commit):

Actually, your tree is based on -rc2, so you need this patch already (it
should have bee included in the merge commit 841577c3d33b ("Merge branch
'for-john' of
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Feb_2014_13_22_24_+1100_Ukvw2TKX7fQSjt35
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/CxkAAoJEMDTa8Ir7ZwVLPAQAJLZm51DivyXOOWg7plKK8Bz
AR7TL19aYem8pdh0lVXzcQrIb2IDdE1TryX7uwB7D3l0zeh9Ox3wm+3GuFWoGyT6
u71BS3CgoUY2F1e6Yy5f4QJSoSiH94scSB/m5qt0y8y/Fd86qkzTaPnM9K/ljpyo
CkOQ+gmQjxZEo1vsswMbKT0BMXr60xsy1FdPePLWuGAU6dRiNY4f392nPA0oM33H
wQCG1rF0OVNG3C8oaOsc6r/l0E583m++9srH8/kIZoIIdRi41E4zPinuuMM0Jb3M
Pvsha0QoZxrHgLsH+en+4pQ0F7QI3Bv6P0kdVH40QsQwNu5FZIx+ar7ipjNef0Zu
+lTnmIym9AbFW5wvNeBwnQV/b47ftGTpU0IZOPhMM3C+1h7TFoEtw7+7UhcUEf74
cmAWrd43jUB1yKImN7Ov6DtbpyXGQ+CbX1WVt1mLVIaVBTg5ZCYnkrqkfwi7tId2
z/4+EhGPso+44KdtF+qLY1ieEMfAe46iucyV7VRhA3dLMzJW4iLWsbehCK2ye49O
wdD69stguAQ/t/v6OupZjvQGJO4uYnnywUE49BX4+9Gg5mcFeoZjKDGCAN3sQoJ6
IoY1GgYqMEycSjxBidPUZUH5/RGW96Q7Alq0pmTnJCLtyqi+hURPqdATyD41SXAD
uU3hQ0zrINtvd42Iljr5
=TfSM
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Feb_2014_13_22_24_+1100_Ukvw2TKX7fQSjt35--
