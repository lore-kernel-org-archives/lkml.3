Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab3JPTGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:06:52 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:41167 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab3JPTGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:06:50 -0400
Date: Wed, 16 Oct 2013 21:04:32 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree
Message-ID: <20131016190431.GA552@ulmo.nvidia.com>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
 <1381949500-501-3-git-send-email-treding@nvidia.com>
 <525EE1BC.3050605@arm.com>
 <CAMJs5B85FwnXN3YE5-KagSjYDH0aSeVYgcwvSXy8=LGfw=STaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <CAMJs5B85FwnXN3YE5-KagSjYDH0aSeVYgcwvSXy8=LGfw=STaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 12:02:08PM -0700, Christoffer Dall wrote:
> On 16 October 2013 11:58, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > On 16/10/13 19:51, Thierry Reding wrote:
> >> Today's linux-next merge of the kvm-arm tree got conflicts in
> >>
> >>       arch/arm/kvm/reset.c
> >>
> >> caused by commits e8c2d99 (KVM: ARM: Add support for Cortex-A7) and ac=
570e0
> >> (ARM: kvm: rename cpu_reset to avoid name clash).
> >>
> >> I've fixed them up (see below). Please verify that the resolution looks
> >> good.
> >
> > Looks good to me (I have the same resolution in my own tree).
> >
> Yes, fix is good.
>=20
> This will stay a conflict until kvm/next and kvm/fixes merge, which
> doesn't happen before after the merge window, usually.  If that's
> going to cause too many headaches, maybe we need to talk to the KVM
> guys (cc'ed) about a solution until then.

It shouldn't be a problem. Mark and I share the rerere cache, so unless
the conflict changes somehow it'll get resolved automatically in future
merges.

Thierry

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXuM/AAoJEN0jrNd/PrOhfWsP/3SbVtBzRqeR7BAHZn9bn9fY
nTv6EfN26Yx2TjY23kShOZmdROOIYZKEaomxCDzM+KnNI9e7jhA/3EjW4IrvAXTt
Zq9AoiP3hWc2SBe40e2dqemJMhOLuDNE3eVlke4YwV2QQxSRvd6oQAcGVi8pTq4h
4LMAt4WFAK4BjUXFFkju0rud3Pn44k7T/3nEe9YZf6vJ6p1ka9lKCRvSftlG2ASv
EjjhnlYgS8U19Hp/PyJwtZSOOHiLiZJGqej1IyBI3XhVobr6X38EiEgTMG4iB7Hw
LV+Z3vW4/XmJqs4uFBOGLat2o6pD+7rdnF3vmQi/Ho+rXGEcVrfjD7zNi7P2TNB+
io1Of+I0+2+D9Xcp1nLBZSeVmDoNRZPnVdMCfyoED1bIOJct+0rPShiArnw9OVIc
/6Ax57x9+GGo6sdWO3vmMrwd6nm9dwC2zAdLif0FtvpXdzgLA2xt6YPtIilzwa1d
mpmIcyBKHnTdBr77zRO2V4iJiXv17AW2bDGbOBvxGtn8QMBhqEOj5JOjY6JTTw4n
8UrmeFqNHxspafJfocL3BTie67lrzGa2nAhTX6weLfH7eXfSg9yUI5E+8aHZabyq
XofAqoBFrw1mIJo71+WZOpfbQ2HoU68D8k5VoqgjHDPINX22yoVXnkV1IaRKcc5Q
nyFmTEOVau181yMUHBYT
=/zPs
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
