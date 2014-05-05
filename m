Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaEEK0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:26:38 -0400
Received: from ozlabs.org ([103.22.144.67]:46420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbaEEK0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:26:36 -0400
Date: Mon, 5 May 2014 20:26:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: mtk.manpages@gmail.com
Cc: linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: linux-next: Tree for May 5
Message-Id: <20140505202628.7f406c1b77e05d0ad56db54c@canb.auug.org.au>
In-Reply-To: <CAKgNAkj4hsTBqfD72ZhoCrHdV4S_68tJEQ_AaE0KWO_cySqeHw@mail.gmail.com>
References: <20140505171459.3ce28e8e0c4d6b107a66eb97@canb.auug.org.au>
	<CAHO5Pa0D8bxBV98feBt2qk_gb3XdTDcmaa6bD7eQv4UOdjcFrA@mail.gmail.com>
	<20140505195711.fcce1825483f7a1ce707c2c6@canb.auug.org.au>
	<CAKgNAkj4hsTBqfD72ZhoCrHdV4S_68tJEQ_AaE0KWO_cySqeHw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_May_2014_20_26_28_+1000_B=/oppWKcQrFfWzZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_May_2014_20_26_28_+1000_B=/oppWKcQrFfWzZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Mon, 5 May 2014 12:06:27 +0200 "Michael Kerrisk (man-pages)" <mtk.manpag=
es@gmail.com> wrote:
>
> Okay, must be my problem then. Sorry for the noise. Somehow, I'm not
> syncing my linux-next correctly then. (Is the proper way of doing this
> documented somewhere?)

Yeah, in the stuff you quoted :-)

"If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below)."

then later

"There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel."

Unfortunately, that site seems to have vanished :-(  Seems like I need to
update my daily release note.

Since linux-next is rebased and remoerged every day, you need to "git
fetch" the tree and then "git reset" to the new tree, not "git pull".
The latter will try to merge the new linux-next into the previous one  -
which should normally make a read mess :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__5_May_2014_20_26_28_+1000_B=/oppWKcQrFfWzZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTZ2daAAoJEMDTa8Ir7ZwVY3AP+wanYxm5lAEH2l9hOQibzl56
u2IBKxQj0jsAWcTMzlD0o9ay7WzminEr9kGaP55Fd3Ts08uDve6OucFlGOJWVWD+
V+2apvTmfQAjHEinaLkv2eRF5jkoUJpIEA8QUly+PHCXBjKpkeIPaDgRG+enJgde
BEWJmnmH+fOJ/i1ChfXEXwWYQe2mCyvseNGXyC4IWz1uvhTJHbeQaUXe4WBB7jHh
z8/rGxh0K9GNcYm78AF9G1Z/NGPTzNBBWrlRuLwApWjC3urknYfV7z5pworkksEa
7c36hmJX3t6RNxfN9C/uX4G4gcJEXpxnypm1RgZegrzIRY3MvwPfV7uGOn04jQNS
fhrMBDrNiwjurLWDb0ha9kS6Hpicj3g1ipuhe3hkxgUaXGDpfFKEFIorSy+wMN48
iydY16lpG1Po3oG+qf2agdJF3l+uojOptrBcAXurAm2Z/4MmVDinFh6YQbEoQPyY
tFcOxWPga4/5Uq4tKUPt6zesAewfqmgBCDtuvHOfX1fHr21BouaEvObUjLcx2ecQ
+CiV8pQ4meWXorrpvUnGJbABMI6Y/9SidXUga1OybWtDtD71iHh1qPAwaKGTXlhr
0JnZyFffMdGxBGEgkfJEmS1srznKfOeJKMjrj6lg+J7LcPvHKcojtcejwBXbyILE
undczOsq0dbwLGR3gJs0
=Wzvj
-----END PGP SIGNATURE-----

--Signature=_Mon__5_May_2014_20_26_28_+1000_B=/oppWKcQrFfWzZ--
