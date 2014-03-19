Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaCSUar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:30:47 -0400
Received: from ozlabs.org ([203.10.76.45]:43021 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbaCSUap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:30:45 -0400
Date: Thu, 20 Mar 2014 07:30:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolin Chen <Guangyu.Chen@freescale.com>,
        "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20140320073039.0ca391a3b8bbc47274ca1efc@canb.auug.org.au>
In-Reply-To: <20140319101701.GU11706@sirena.org.uk>
References: <20140319121000.ccea7c0440649976ae722abd@canb.auug.org.au>
	<20140319101701.GU11706@sirena.org.uk>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Mar_2014_07_30_39_+1100_e.KRfo4++RjW1O/S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Mar_2014_07_30_39_+1100_e.KRfo4++RjW1O/S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, 19 Mar 2014 10:17:01 +0000 Mark Brown <broonie@kernel.org> wrote:
>
> Sorry, it's fixed already - your fetch must've raced with my fix last
> night.

No worries, that can happen since I fetch all the trees before I start
merging.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Mar_2014_07_30_39_+1100_e.KRfo4++RjW1O/S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKf5zAAoJEMDTa8Ir7ZwVSmcP/2khdopLpkekEgsoaHU76ZLQ
IPS8HYCps7Z0kpjPO9isArFzsiK5gk3IbIb341qTIqPAtDDATSohffCFMVNNxa3+
xXX2OlUC97xjtnYdcRgcI5ufOVX/lQ6X60VDAVRH2Y9BPTjXIUylp+NPFnLDCzxw
EKm3FssFzY645aRzuX+M/eDfgnvxLVET969iwLUAtQ5OfaECqXNwMfRGzpv4fklc
VRgXQqlFmcfd8frfuQsDDPYpYbcGPe/Jm/sUuK/t+yVMOtZUkUH/jNgoYWSqQy1v
ddGM6LebI0IKpqwHdqUXp3r2a92+vZIMxvsZIB8/lmLHV4grxs4HdcIiXoNMtyTk
EbbNYEyuwyQc0Jq4RzspLeasCa+ErEdBB3pFtHLdGqmsFasdtPHTHJN8JQg1qFvJ
iT/tulqGFGBFVyAScxwThswTS6suw7mPUkqFl9gl0Duu+5l+mOb6PCKvhx2CzRq7
X6WLZUBwkffO4Iqjr6h35kJZx10UcSu0q0ELOXqXPzQuslvC0aaopSYNEvwjS/4n
g8XkBjTLufzAHXsvHXYBFDIrfOxGyqS5UDrlbZEpAjbiU/0AGu2isftxU/9QMevv
LsScQ1MkPlWdgCklKfB+l4QhRktp4wr9hicC0I/BSlAuhS67IcR762FPIeoTMQp0
PiSe58QJlqg1yPozzwTs
=qe4n
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Mar_2014_07_30_39_+1100_e.KRfo4++RjW1O/S--
