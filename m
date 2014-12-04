Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaLDUOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:14:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54488 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbaLDUOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:14:01 -0500
Date: Thu, 4 Dec 2014 14:14:01 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
CC: <balbi@ti.com>, Nishanth Menon <nm@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Add DRA7xx CPSW Ethernet support in Device Tree
Message-ID: <20141204201401.GA18419@saruman>
Reply-To: <balbi@ti.com>
References: <1413885661-4850-1-git-send-email-mugunthanvnm@ti.com>
 <54463063.80207@ti.com>
 <20141021172223.GA12943@kahuna>
 <20141103162722.GN27425@saruman>
 <545BA9EE.1040905@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <545BA9EE.1040905@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 10:33:42PM +0530, Mugunthan V N wrote:
> Tony
>=20
> On Monday 03 November 2014 09:57 PM, Felipe Balbi wrote:
> > On Tue, Oct 21, 2014 at 12:22:23PM -0500, Nishanth Menon wrote:
> >> On 15:37-20141021, Mugunthan V N wrote:
> >>> Nishanth
> >>>
> >>> On Tuesday 21 October 2014 03:30 PM, Mugunthan V N wrote:
> >>>> Adding device tree entry for CPSW to make it work in Dual EMAC mode.
> >>>> These patches were tested with DRA7 hwmod patches on top of linux-ne=
xt.
> >>>> Patches are tested on top of Nishanth's PM tree for v3.17 [1] and pu=
shed
> >>>> my tree to [2].
> >>>>
> >>>> Did a boot test with CPSW and ping test with suspend/resume, the boo=
t logs
> >>>> on DRA7xx EVM are posted at [3]
> >>>>
> >>>> [1] git://github.com/nmenon/linux-2.6-playground.git testing/v3.17/c=
pu-idle-suspend-dra7-omap5-framework
> >>>> [2] git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git v3.17/d=
ra7-evm-cpsw-v3
> >>>> [3] http://pastebin.ubuntu.com/8613072/
> >>>>
> >>>> Changes from v2:
> >>>> * Changed pinctrl comments to hold mode0-name.mode-selected-name
> >>>> * Changes slave numbers in the pinctrl comments
> >>>> * Added cpsw and cpts clocks
> >>>>
> >>>
> >>> I have not added support for dra72x-evm as it has only slave no 2 pin=
ned
> >>> out and having issues with bringing up the interface, need some more
> >>> time to submit the patch, in the mean time I have submitted dra7-evm
> >>> support only so that people can use dra7-evm on linux-next.
> >>
> >> Quickly tested as well:
> >> http://slexy.org/raw/s2vISJxYrR
> >>
> >> Please feel free to add:
> >> Tested-by: Nishanth Menon <nm@ti.com>
> >> Acked-by: Nishanth Menon <nm@ti.com>
> >=20
> > I've used these patches with X15 (DRA7xx-based yet-to-be-released board)
> > with v3.18-rc2.
> >=20
> > Tested-by: Felipe Balbi <balbi@ti.com>
> >=20
>=20
> Ping on this

another ping on this

--=20
balbi

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgMCJAAoJEIaOsuA1yqREkLwP/RUy9lfGwH5FY6CoathimTd2
b1zNIVdQhc5jxTycJfCpfeOuQzfoTBwkZxbITq5/Al/BBPVGYaNESlXoHdUAgKHY
ro0VBdbQBNgkBAky4oCRa6f92yg0FSJ9R37ax0PXKHtRhsJS1Rvc8VsmayqG8eDD
8XvhtCqitlpdatem7RdzaNPj6j9rRUzQ0CRH17m9FoNtMGMCC1uqDeNauiLtd2V/
ouFxYjvpWPE0vbGiNCBc2/kQuHjso5SAoF4ncKYF3g7fCi3jCyOpqpQM6PLJVKpn
djIhsYsBRgoFy7pQu0Cp6Rp87CjjbIIPHYSvTaZOdwpAhnMNFPHJ3KJifjV6j/lM
LxvRxcBKoDmCgAV+E0w8pN/Yk9dqvXiXvWgjGFiqmZFO/+4Y7JgU9ttnQLXQY6+6
SI+b5GiRxa9lK0YkpZIcxYm6W1XWM6Sa9CchCnqgNZiWfED9OJomRDiwjvVaq2NK
xNDctcl8vZcna1s/EOzYT8QJCQTYoP4mzoPpXDAKnDo/bYZ51swXdW+RqGUCwsHd
jWV6ZyvI8zd/SsCOg/ZLjWfVgWVGOLxl58PHU+G3S7kDjqRSr4kqeE2jZOXg9afI
4ds8LkGeaF9yDUqmyA7dblEjS7II/tZXv0DG+ewwmN9j3hhMZGyRJdcJRMQq5DII
7In0Pi9acNA9OFV0naIn
=jCEj
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
