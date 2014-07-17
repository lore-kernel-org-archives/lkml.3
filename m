Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965711AbaGQQWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:22:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41498 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933966AbaGQQWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:22:12 -0400
Date: Thu, 17 Jul 2014 11:21:47 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.16-rc4
Message-ID: <20140717162146.GL10459@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404153635-10868-1-git-send-email-balbi@ti.com>
 <20140701045957.GA17105@kroah.com>
 <20140717150856.GH10459@saruman.home>
 <20140717152657.GA26348@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f54savKjS/tSNRaU"
Content-Disposition: inline
In-Reply-To: <20140717152657.GA26348@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f54savKjS/tSNRaU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 08:26:57AM -0700, Greg KH wrote:
> On Thu, Jul 17, 2014 at 10:08:56AM -0500, Felipe Balbi wrote:
> > On Mon, Jun 30, 2014 at 09:59:57PM -0700, Greg KH wrote:
> > > On Mon, Jun 30, 2014 at 01:40:35PM -0500, Felipe Balbi wrote:
> > > > Hi Greg,
> > > >=20
> > > > Here's my second set of fixes. Note the revert of the patch Michal
> > > > asked to revert.
> > > >=20
> > > > Please consider merging to your usb-linus branch. Let me know if you
> > > > want any changes to this pull request.
> > > >=20
> > > > cheers
> > > >=20
> > > >=20
> > > > The following changes since commit 5d881802c407d83c169c875dad88fe2b=
ba066c33:
> > > >=20
> > > >   usb: musb: core: Handle Babble condition only in HOST mode (2014-=
06-19 15:43:07 -0500)
> > > >=20
> > > > are available in the git repository at:
> > > >=20
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/=
fixes-for-v3.16-rc4
> > >=20
> > > Pulled and pushed out, thanks.
> >=20
> > looks like this is still pending and I can't find them either in
> > mainline nor in any of your branches.
>=20
> Really?  I just did a pull and they all seem to be in Linus's tree for
> 3.16-rc5 for me:
>=20
> ~/linux/work/usb $ git b
>   master     1795cd9b3a91 Linux 3.16-rc5
>   usb-linus  1795cd9b3a91 Linux 3.16-rc5
>   usb-next   46865bf3d6b4 Merge tag 'usb-serial-3.17-rc1' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/johan/usb-serial into usb-next
> * work-linus 1795cd9b3a91 Linux 3.16-rc5
>   work-next  46865bf3d6b4 Merge tag 'usb-serial-3.17-rc1' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/johan/usb-serial into usb-next
> ~/linux/work/usb $ git pull git://git.kernel.org/pub/scm/linux/kernel/git=
/balbi/usb.git tags/fixes-for-v3.16-rc4=20
> remote: Counting objects: 1, done.
> remote: Total 1 (delta 0), reused 1 (delta 0)
> Unpacking objects: 100% (1/1), done.
> From git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb
>  * tag                         fixes-for-v3.16-rc4 -> FETCH_HEAD
> Already up-to-date.
>=20
>=20
> So even if I wanted to pull these again, I couldn't :)
>=20
> Take another look...

heh, I need to sleep more. Wonderful how many problems a git fetch
solves.

--=20
balbi

--f54savKjS/tSNRaU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx/gaAAoJEIaOsuA1yqREa6cQALJW5of13vVbvxyy9rv/gRSB
WlGg0fDSXM4BLN0KnYg41TmOfeZBgOLDawG+8s7P+c0qlWpsfnG6JLfK9Aydipyb
rFVqbBg0E/jAgmPrVgk5HCDBnWZHpCR19gOSZgsIeKbr/dhAPyaR6hFjtGu9DXGB
vGVrbv9GtmKqzesVKcm4eCJBv1EblgxYVqYuIDYsJh0Zp3rT/KYv9DNqHtueFvsj
Dei+GM+jmqLeeGoYGxlJHrfp8UOz4UYGNTWgNBmrzjgchjqENgOY5cYSjIdbya+r
gr/XugHJkG3Swm4GgV6zbr720u+RrsHRCqRt/e8t0x/5tlKtAKkuGY6UdG3yzxso
bMSUt19MeC0+ST9o2Te/3lOVBLsb2mWjk4qMw0UgPeAy9FtQ2tEkJ2J//s/C+FUh
yRSMvXn4BI0lIvkdaVDUieZk2DJBJg0f0idufqgz0Nk0fuXOMbREtCPYZMIhXXlV
v4CjBb6rH2dY5BrNg21OtqUDsDuvpOLt1QA0+PneZqGb5At8Ts7Nfr4La65SZ62B
O3wygYO8zQGsvBAkWTNtVFnto7R56MyI1hpDkTy7xcSuGf/pCveEqmRaSh1ncs84
ICjcYAGFCTmrZtcN7SG7Gfy/ViIf0WffFE+EXNumjkDfkDPx7c36mqfoyQmWe1cE
2xU+K3FsijoRBWAp0XzH
=MgIT
-----END PGP SIGNATURE-----

--f54savKjS/tSNRaU--
