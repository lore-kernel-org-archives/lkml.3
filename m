Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaLHOVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:21:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37596 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbaLHOVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:21:08 -0500
Date: Mon, 8 Dec 2014 15:18:07 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 00/61] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141208141807.GC8739@lukather>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141208061746.GD16827@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <20141208061746.GD16827@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 11:47:46AM +0530, Vinod Koul wrote:
> On Mon, Nov 17, 2014 at 02:41:54PM +0100, Maxime Ripard wrote:
> > Hi,
> >=20
> > As we discussed a couple of weeks ago, this is the third attempt at
> > creating a generic behaviour for slave capabilities retrieval so that
> > generic layers using dmaengine can actually rely on that.
> >=20
> > That has been done mostly through two steps: by moving out the
> > sub-commands of the device_control callback, so that the dmaengine
> > core can then infer from that wether a sub-command is implemented, and
> > then by moving the slave properties, such as the supported buswidth,
> > to the structure dma_device itself.
>=20
> Okay managed to get this done. Apart from the two issues identified didn't
> find anything so applied and pushed to a branch
> "topic/slave_caps_device_control_fix"
>=20
> Today did some compile tests and found few warnings, were trivial but I
> am worried about the testing of this code. Has anyone tested this, if so
> which platforms are covered Since I pushed base branch last night, Feng's
> bot covered it and all was OK. Looks like Feng's bot doesn't have wide
> coverage of arm platforms, wasn't there one run by arm guys which tries to
> test and boot, if so can we get this tested there please.
>=20
> So bit sceptical for merging now. I will send the patches which I have
> applied on top of this

Which is why I wanted to merge this at the *beginning* of the
development cycle in the first place....

These patches have been sent more than 2 weeks ago, and were exactly
the same as the ones send at the end of October, rebased and updated
to take into account the drivers that were merged in between.

In short, these patches have been hanging around since 6 weeks. I
relied probably too much on the intel's build bot. This is not a
mistake I'll repeat. But blaming it on me because they came too late
is *very* unfair.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhbMfAAoJEBx+YmzsjxAgA1sP/jpMIO1HZ3z4pSBEX/xgxFLR
Xc2HcODjRuoqtVWR4C0Vc0fzgnzojHcuZ8avAZcODad8pNLswaeouu/3WhMW0jbT
6aG/b0jzpTtC2vqnL6K7lpMymzOnVfCwi+dfLkTyS5HUtlWT7VzZh7bWr0w8QZO1
ksRPwCvcXwhXkbUUf9OxgB3Nb/gpq5FlEkZ2qcqr0ZXJhxxkDO75PNpbKavh0Tob
6RHbe3V9CzHSivA9mcx9UnfNWXSXWiXW29/CtBUKe22GYvyYiVNqupSO/9uGY7/a
y9em1WnFnjFnDbk51oEbuRCaViTv4+Qym+k2suYNQuOgrrjpQ+8cV9BVkzcxGjhX
KHyQpR2uvube/WorGoQco4mFIMvcoMByChiFG4BFRMAfs7RdocGdNzJvSbOOcmUD
lA0g0+ebSMBhI+OHp4dYys89rIeaBBdDpmZ60xEz98FAbB/NSqqXIpi6k0lhRCS+
iu4xogrzQzJ85IzTqlX2WCwYo2abz9qrvZw0bhyXc/p4NQOrwjM56ZjVUk7PCeWQ
zcDym68r3g4Rn0tWCQDHWvZGvDR06X3ttDuWHB8/gkhm5ezSkVd/E4UAIXCxkNhH
tVtkkeOu5Kp3V0W6RHSpPGpuTzC7p8M933tm2xfm63uLYEFq1NlBWTSQAvEyGA5f
klQthQZNXhph45i6svZg
=/spt
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
