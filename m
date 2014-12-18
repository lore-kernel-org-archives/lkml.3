Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaLRQeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:34:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:38288 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaLRQd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:33:58 -0500
Date: Thu, 18 Dec 2014 17:33:48 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: reset: augment versatile driver for integrator
Message-ID: <20141218163347.GA18639@earth.universe>
References: <1415100672-31425-1-git-send-email-linus.walleij@linaro.org>
 <CACRpkdZUZJmSrHVH4BbNbANgN-BphYL_wCF=6QdXndXdXYXiZg@mail.gmail.com>
 <CALT56yM15FbKm6RKqUe59cWtMSfZgOR7koYcgM_J3F_TyHp2WA@mail.gmail.com>
 <CACRpkdaPx_xqu5S9ATJNzWDUCgL9hQmvbVSa5ehbxDUtfKh95Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <CACRpkdaPx_xqu5S9ATJNzWDUCgL9hQmvbVSa5ehbxDUtfKh95Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Wed, Dec 17, 2014 at 10:34:58PM +0100, Linus Walleij wrote:
> On Wed, Nov 12, 2014 at 7:20 PM, Dmitry Eremin-Solenikov
> <dbaryshkov@gmail.com> wrote:
> > 2014-11-12 17:54 GMT+03:00 Linus Walleij <linus.walleij@linaro.org>:
> >> On Tue, Nov 4, 2014 at 12:31 PM, Linus Walleij <linus.walleij@linaro.o=
rg> wrote:
> >>
> >>> Augment the Versatile reset driver to also handle the core
> >>> module reset sequence used on the Integrator/AP and
> >>> Integrator/CP.
> >>>
> >>> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> >>> Cc: David Woodhouse <dwmw2@infradead.org>
> >>> Cc: Sebastian Reichel <sre@kernel.org>
> >>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >>> ---
> >>> Sebastian: please merge this into your power tree if you're
> >>> OK with it, the corresponding platform changes are orthogonal
> >>> so these can go separately through the ARM SoC tree.
> >>
> >> Power folks: ping on this patch.
> >
> > I will apply tomorrow, if Sebastian does not respond earlier.
>=20
> Just checking: this is applied and *will* go upstream this merge window,
> right?

I haven't heard of Dmitry since then and it's not in the battery
tree. Please resend the patch (its no longer in my mailbox) and I
will apply it to -next immediately.

-- Sebastian

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUkwHoAAoJENju1/PIO/qa33EP/0T+GTP4JG2lFwIGs4N1WlpI
A0rYnH7Qb8zx4vQT2L9C4nrgh7ooA5hHjmm3Sv5GoVpbvpCJgxHtUC1cQb3ZjDIN
APzyR7grOBNqJZxpzNFr3uXLOpGMr/z/x2Hi0/BspOFKMr0ElxhcLobU595EtDRQ
pMXDXlV53DMxjbnsHHDAd4BH3UgdJmq2UXg8nKy5OljKNVGHSw2miMA3aDhFUXqr
kooknEDVdNnckFNLJPk9NxpKZInkd6xjbfIchtEDdwZS6QCgZ9SQ6WG/Tk+t+SJO
I9ht3QdI+bs8CMhryuKl7lC3icMP7di0HvW3lojQ4FS+MfRWIRoSPgovwCihy/jQ
B5cvCypDuz21iQOHUKZZYd5fCuo91VLA99bCrUDQi3jjzMiX13RBvLmyhytFjZ5d
UfA8URm/B0ZjmV4dEzPU3QiBvua1LkKJ6lBWsmnHF2lt9iJ4welsJslmBu4ToRDP
QtbqYC7+jWrntw98eUSxN/IGLvVHnHU74fPUmIsp7h7Q7epdth3Qy0xsgKWGPnHo
V66buIASO/gYv68HAA8W1bfviZASCjfWze7fbMXGVoHBuhW+B8UqE5qKKjLy3Lk8
yFc16bBMBmscQc9msUPbD/1HuJiMf4d4ULWyVOVc0L8mHDAr3g3zqw1lGL9uvB1P
4BmnqNKgQ11NCCtSVVa5
=JrUx
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
