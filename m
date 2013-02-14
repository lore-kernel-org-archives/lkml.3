Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934848Ab3BNTRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:17:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49216 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab3BNTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:17:49 -0500
Date: Thu, 14 Feb 2013 20:17:45 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130214191745.GA13875@avionic-0098.mockup.avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
 <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de>
 <20130213225311.37FFB3E3557@localhost>
 <20130214165341.GA29199@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20130214165341.GA29199@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:S/bT7e1v0BUCTxEmf3z9pdiPc+tsSF1zX+7Z8Rt2PGW
 6tJS+Cd2gfREcPBb8wTQxUGKwdzqfx9+tkFBngxM4zgEbjZLUg
 NSm8EWtYIFW2QqYap4cUfSR/51MDB57M2YxYNbuWBoNsbkpl7H
 4ZOBd+P2NGbRwaqMzRIhmzKFUsH4YA2/vveHcxUzKe0+hRYzZd
 h8KRbxf84OGoGIrdzCPZeUBdp2+G9LVfGjt/CmQ2HQqov1G81z
 jrw6HXL+sAJy+4SXr0JmWr6ZV4D2N6oIOk0mc9UZTFftbCcQnt
 qdj2znuu33ro2iI5y6DW5FIT8FG3rKJYCxRls9FjLTL7lSiiaF
 VMqGKuKYbguYjIIsG51DC8hlDS9InQb/+796oP8vRHMe2GRO9a
 ilgoWUNTVDheP0vqouEyKI3NjspEP0CVFOff2QdNYygH2/oc5R
 5k+99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 14, 2013 at 04:53:41PM +0000, Andrew Murray wrote:
> Thierry,
>=20
> If you don't have much bandwidth I'd be quite happy to take this on - this
> would be beneficial for my eventual patchset. I can start by refactoring =
common
> implementations of pci_process_bridge_OF_ranges or similar across the
> architectures as per Grant's suggestion? I didn't do this when I first po=
sted
> the patch as I was concerned about the testing effort.

Absolutely! Since it was your patch in the first place you're just as
well suited to do this if you want to and have the time.

Thanks,
Thierry

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHThZAAoJEN0jrNd/PrOhqSwQAJn6VuXVWNnJ8Lb8M0Y0UGjA
8afkXuqdUqQ7SVhrFKbd7uMavtROFGAICIHvvs9bj0jyGJRY4rE/Xp+UvEha/1sK
3YMaOw++5yIFDDO22zTbsvVyqNCl86eGsLdLIR/r4bJ+YsAe2EKvOu+S9s1IYf6x
24afZfTwhUtJvkbIBH/PwPrUGp6V6b5r9k0x138+rAd3YjsJq7FByBcRzQGD9nu8
4n1IN65DRENoDs8vWM/V7g95FStfrRaBMD4JtLoht8dI4yS9tvj4UvLWxexUIgWQ
52GltAwUm6T2bXHQ5Y8PlOvyvP6q6TjAFhI+gMfrADMVTVq+fGQaEGKhZzkEYrIv
n0g7JxS74Hmpna3wqR2fS/RzsC0LqWIVXKpymRXzYAhlJt0JRcrVM89Qp4qZFVEc
Vw1ehWlx4m+tAWb2a551MmczUgGqSIt7rKtrdeOP7hVktvbtOzwKQErP/NvI4A+h
e9CQNXxsOYPS5MAK8qAc8qC7TBlT+UHnnqH37pXXdQgDIfRYZemHqHpDGJxpHd1m
a07jA1r7bA7CMXe8RqoOjNeA0IReKI2uwDMIOi2zpKElOZA828pjt7sqKo4hg/7V
1AAgI3w2ffyi+Hdfz+urVLGxOxgQvxWfiDos/oFSvvDeUmxk89Qdc9U6F66wfgTC
O2R1HPhT/2fNB98R4JEO
=qUDq
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
