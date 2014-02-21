Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaBUJ4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 04:56:14 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52264 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaBUJ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 04:56:10 -0500
Date: Fri, 21 Feb 2014 10:56:07 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 00/11] SimpleDRM & Sysfb
Message-ID: <20140221095604.GI22574@ulmo.nvidia.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
 <CANq1E4S=+ixMQRMfX2-DXh3ZDO0jNAdWrUe6=z9aTdOSfR-SDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WR+jf/RUebEcofwt"
Content-Disposition: inline
In-Reply-To: <CANq1E4S=+ixMQRMfX2-DXh3ZDO0jNAdWrUe6=z9aTdOSfR-SDA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WR+jf/RUebEcofwt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2014 at 11:18:51PM +0100, David Herrmann wrote:
> Hi
>=20
> On Thu, Jan 23, 2014 at 3:14 PM, David Herrmann <dh.herrmann@gmail.com> w=
rote:
> > Hi
> >
> > Another round of SimpleDRM patches. I somehow lost track of the last on=
es and as
> > this is a major rewrite, I'll just start at v1 again.
> >
> > Some comments up-front:
> >
> >  - @Ingo: Patch #1 and #2 are unchanged from the previous ML discussion=
s. I
> >    included them in this series as the other patches depend on them. Co=
uld you
> >    pick them up for the x86 tree? The other 9 patches won't make it in =
3.14 so
> >    no reason to put them through the DRM tree.
> >    All mentioned issues should be addressed. If there's still sth missi=
ng,
> >    please let me know.
> >
> >  - The DRM patches depend on my "DRM Anonymous Inode" patches. But it s=
hould be
> >    trivial to apply them on drm-next (I think only one line needs to be=
 changed:
> >    i_mapping =3D> dev_mapping).
> >
> >  - I tested the SimpleDRM fbdev fallback with linux-console+Xorg and it=
 works
> >    fine. The DRM backend is only tested with some DRM tests I have loca=
lly. I
> >    have no idea how to make Xorg pick up a specific /dev/dri/card0 card=
=2E It
> >    always tells me "no screens found" (as the underlying device is not =
marked as
> >    boot_vga..). If someone knows how to tell Xorg to use card0, I'd gla=
dly test
> >    this. But I'm no longer used to writing xorg.confs..
>=20
> For completeness, I tested this with Xorg+xf86-video-modesetting and
> it works just fine. The xorg.conf I used can be found below. If this
> driver gets upstreamed, I will try to make the X11 auto-loader detect
> it just like any other platform-device.

I recently posted patches[0] to the xorg-devel mailing list that I think
should solve that issue.

Thierry

[0]: http://lists.x.org/archives/xorg-devel/2014-February/040568.html

--WR+jf/RUebEcofwt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTByK0AAoJEN0jrNd/PrOhgesP/iVDOlFV9SkAv8OK1GY4dmfs
cqOKH9TaKTBenMRgEb276Rm7nbdbRzmkM+GVjjhLQiYa5JTs9CGxcaulhWMFCrcf
BeUkDBFnh8QRcMBBS6l+d1hZT9yNvSv85VqIfkdkEtwzIBznRo48gnhOdlq3AMyl
l2f/hkUkDzImIRdZZpawk5NIZqqb5FWNjUL7p9Hn8q1jN89J3RvL8Gaagaa0XTJK
ccCfHQR36AbLC8PlO1B4Ovc909clsWRelzWm+615lNBBMm+GCGhzGDCGHzsJ+r7G
HWMsy73ORiemlDm2/dYvKAqcYy+UULm3foeIBqiBQDF9Fd7eJFtOcTDeTaI4HN+O
XQsvRnlxNbLC8r6f1odpqnl373dEnEnqNSCe8nkEkC8UgERTy7+ZOzUKR4F9BgkQ
U0LJRM4fS7BpkrhjxJR9JhrI7gCKimRhwItQXNYxr34BKdJxxQr8t53hxKJscFNj
5WxGW1S/r4TvOdFbShdu+nSE72TuzLzI7ew3kCB9gC45JbNgcZ4ahfNiX1OJPJso
tNZSiVL76pWVNnplfIeOny8j6gk2cwZnk/yZrUDot/RQiMom8fHFOSpt4fW9zgHB
5Pu73hj8EkUAUSrX6AtbS2NgRqFY7X5PGEsTb0otxHESFeA0r5rsls79KBQxkqe/
UNkQwLbcE+Tuv/+WVmfj
=gS6g
-----END PGP SIGNATURE-----

--WR+jf/RUebEcofwt--
