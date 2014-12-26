Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaLZBds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 20:33:48 -0500
Received: from ozlabs.org ([103.22.144.67]:59540 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaLZBdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 20:33:46 -0500
Date: Fri, 26 Dec 2014 12:33:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: question about the luto-misc tree
Message-ID: <20141226123336.30fba599@canb.auug.org.au>
In-Reply-To: <CALCETrXfc5SpjOUfRuj7d5Kzushjucw-njcGT+XW6L26c3BFyA@mail.gmail.com>
References: <20141214175747.2e6c506e@canb.auug.org.au>
	<CALCETrXu19aHhudTfPAr5PM05FR0xKBiSHgbubVhh6QUrHCADw@mail.gmail.com>
	<20141214120318.GA5310@linux.vnet.ibm.com>
	<CALCETrWsy5sxVTmjNu7t+o-QvEVY-csQHkP-PXT1aMFiXnzzhQ@mail.gmail.com>
	<20141214173715.GB5310@linux.vnet.ibm.com>
	<CALCETrWT7SLO3E+nV2g=QzJHAeWU4FBRENq=7OvoNDrHA7W0fg@mail.gmail.com>
	<20141214181744.GF5310@linux.vnet.ibm.com>
	<CALCETrXfc5SpjOUfRuj7d5Kzushjucw-njcGT+XW6L26c3BFyA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_75hP9cjR/ZvR7.8GUJKSyP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_75hP9cjR/ZvR7.8GUJKSyP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Mon, 22 Dec 2014 11:16:56 -0800 Andy Lutomirski <luto@amacapital.net> wr=
ote:
>
> I'm re-adding the branch, since 3.19-rc1 is out, the change appears to
> still exist as-is in your tree, and it merges cleanly and builds in
> the latest -next for me.  Let me know if this will be problematic for
> any reason.

So, now we have a problem because Paul has rebased a whole set of
commits that you have in your tree.  Commits c6dc129cf2d1 to
f58d100f65ae in your tree Paul has rebased on top of v3.19-rc1.  If you
are going to base your tree on (part of) Paul's tree, then Paul has to
agree to not rebase that part of his tree or you have to keep a watch
on his tree and rebase you tree on top of those rebased commits.
Really, the first should happen.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/_75hP9cjR/ZvR7.8GUJKSyP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUnLr1AAoJEMDTa8Ir7ZwVIjkP/00wOu3o9vxaFD0p+h0Pceqz
Nm/hEK8/FpL9OJLSWfE87EP/u0zdeZXznOCNMI7P9u3K5tGKQCyb71YLPRwcVzFz
NtFltHoi661DGXCZ6n6UpXikcsfky9B91HVWl+DxjBbDYHeMoq8kW9vtQugmR+l3
Jfkvub3EtRmScGTdGeNVM8UJsaCzlxAaiczl7UQcH8sOlhox60Co4qNbTBVqrvA7
HVbnInaYENRBSuij78zMfgzvwQ9FXpESWNfE9cnych49lx7JvtCRs6kCyTh2jxwP
9u8zNzygj4bNqrasz+HeGsScgsWttNQE7AS9xNYNX3bCkiapin8v/DZo/ipImRLi
WJ2vg6dXSk3ei9jW1K0bMa6CftcjKlvzbzsOXP0TTNPyR+rrMYteknpTwXOkMVBE
ZlzIpbvOhFD0bbD34AxTKOYIN/Aj+pSPXKuQHksIK04J9ZbnP2U2+AJ7F+E8o1lU
4k1y7GPXbmwiPLxA+OmJfiMzfJQ1v1qqMZymAyYxC6p0wemMcsu1hiyrGa7r3ArX
eA+20jN6VNzJAWTVVkNiXT5sfJbsUsel7fyyGyQr8SihpZ2tgjzlPUUwjYCEURQW
d79B6cYni4S2zkQ0A4UHfRjB9U4CaNnQbbTLsWHIlQ5hMi6rmYNDYlkekqLe7Kps
PP0hVGddi/DLmnBZnUOV
=kMIa
-----END PGP SIGNATURE-----

--Sig_/_75hP9cjR/ZvR7.8GUJKSyP--
