Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3HQK1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 06:27:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56206 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3HQK1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 06:27:40 -0400
Date: Sat, 17 Aug 2013 20:27:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Teigland <teigland@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: manual merge of the dlm tree with Linus' tree
Message-ID: <20130817102734.GA12640@rothwell.emu.id.au>
References: <20130816114050.5f4bf4b21f1bde305235ac42@canb.auug.org.au>
 <20130816150441.GA20568@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20130816150441.GA20568@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Fri, Aug 16, 2013 at 11:04:41AM -0400, David Teigland wrote:
> On Fri, Aug 16, 2013 at 11:40:50AM +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the dlm tree got a conflict in fs/dlm/user.c
> > between commit 201d3dfa4da1 ("dlm: kill the unnecessary and wrong
> > device_close()->recalc_sigpending()") from Linus' tree and commit
> > c6ca7bc91d51 ("dlm: remove signal blocking") from the dlm tree.
> >=20
> > I fixed it up (the latter is a superset of the former, so I just used i=
t)
> > and can carry the fix as necessary (no action is required).
>=20
> Thanks, what's the procedure to get the right thing merged in the end?
> Apply Oleg's patch to my tree followed by my own?

Just leave it alone, Linus will do what I did when he merges the dlm
tree during the next merge window (or whenever he is asked to merge it).

--=20
Cheers,
Stephen Rothwell

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSD1AVAAoJEECxmPOUX5FEw74P/0jenVaWFFxXsTo4oKeBGeXs
+NC6JshPMgWqgDB+1NLUjeQwvk4CiXEcSZrqihq7PpFfsQALtYchK0skGyNY3nPp
HQMUWhonUWwmpZsvUrzC9hYty8LWquWRw6PLF1lHVfrHBgtxhi4r68PFD9bOia5Z
viIUaYGnMI6A623Q9fVrcotOfpT2R2PlENbKZv+BXOfQHWZKN4DTaN4tbBei0Daz
yjhk8fAqQv/LGQ14hNh8EkW063UHIosyFJePB4AhhrQtB9sRTQE1RHLxDxdKemGM
5hT5oKrj9qeoJp02eFRnFmo5VtUGyHAyq+EVL7nnTki0+ouT5mpPzYpvcTSU1vrZ
XKyzKLCdEXoA6PLJUYfSY3xomfokokzugd3vvS/kU1msb6KJ/qmzPStjiZuT7cj0
DqlkUAZre5f2PqtqRakSBc4vQ6rVfA7PMyb1zCxMkGh0SZ+6zTf11ScqyioTeodz
7jjDT2dvzzujvKilHZ93A4rlOlcJfgeL9NsRpw2wz2673cXPlBLgt/gVkg7HYXyZ
i/Wm+DEj+7W2GU3m0RSXYIu8BQE3pqxVDQntOvkOlRvc58QFzvOF+VFDt6pwq2lW
sFBHdpj2MbaFI6qvU42V8jCNit/JjVGc2/X9AEJc3ajIpZjwheC4m8LULizcYMvv
a0a15wfpEZdFbaAmDUn9
=3aA3
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
