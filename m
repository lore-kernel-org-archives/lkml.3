Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3FDKFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:05:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49187 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3FDKFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:05:37 -0400
Date: Tue, 4 Jun 2013 11:05:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Message-ID: <20130604100511.GA31367@sirena.org.uk>
References: <1369911393-25747-1-git-send-email-kishon@ti.com>
 <20130530113247.GI5180@sirena.org.uk>
 <51A74D70.5060303@nvidia.com>
 <20130601184511.GC16790@sirena.org.uk>
 <51AA456E.3030307@nvidia.com>
 <20130601210511.GT16790@sirena.org.uk>
 <51ADAE78.4050900@ti.com>
 <20130604093816.GY31367@sirena.org.uk>
 <51ADB6BF.6020205@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b9dEYEwnDXkv9lSy"
Content-Disposition: inline
In-Reply-To: <51ADB6BF.6020205@ti.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b9dEYEwnDXkv9lSy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2013 at 03:13:27PM +0530, Kishon Vijay Abraham I wrote:
> On Tuesday 04 June 2013 03:08 PM, Mark Brown wrote:

> >No.  A boost regulator is still a voltage regulator, it just happens to
> >raise rather than lower the voltage but it's otherwise a normal
> >regulator.  I'm not sure what you mean by "SWITCH" - from the name it'd
> >just be a bypass?

> Copy-pasting Laxman's explanation

That doesn't clarify anything at all.

--b9dEYEwnDXkv9lSy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrbvUAAoJELSic+t+oim9cdUP+gNcD+EkgPegn/GRl2/2UIQ0
Tp/OqLnqMaewq+qlyxELOCBCc0pCPqA4hD5e+LV+lDh5YrUG8kAY9UhMLBx+sfRs
p4q1TExKnogPh5u5+CMbUGDKjI8vEUahwuwtfpp0qpxO2ffX8OV3AWGmY5tpS7Zp
xbGq0tZkYJypQo+8BxoZRbY9gp0/o9mKNYRmO1s87TgmB/9lfbr915n0FQIAnNvl
L5Z2KllBZuw92DyIgzZHKgkwqGabfWP/2790iuqOf3G1ocThIBEQA0x7wg3CY9jl
jJ8gSZ+Qtdh24rlfojvzUMkt3gF4OuKBF6IsJ00Vt0DuV9OlfRG7HAAES2E/s6AR
H84WpCpLM4Vus08oz7P32HAvla+ADQuqbTf0im/LMeWj744qV7lQLrqsOk0urduR
eoMRUXCpRjCRGJMMlf0mbjVY4IRpbmMNQk+9ORCPhEmhKL5YvShmCeD/0HzPPFrt
DhNUWU53SmCrFjbP964z+R1Vo6sRxG1ywSSMnTN3VazrYowWXa29cCCUKVlYNjhN
UBS4N/caJltxkWS402+QFt6MSRC+cX9PNuIxdZNzqPyr9VMs5qlp+YD5Zz8VS2IM
EOQXrIJljiW+WyMqdflYTOaz0GjdH4sUMECzzFU8IOtZ7D0F+Iy0JRBai+MoEFvq
XT0RghPaU0Ju4wT9prNH
=eU8h
-----END PGP SIGNATURE-----

--b9dEYEwnDXkv9lSy--
