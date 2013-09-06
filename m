Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab3IFKMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:12:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44252 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3IFKMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:12:01 -0400
Date: Fri, 6 Sep 2013 11:11:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, mark.rutland@arm.com,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "kishon@ti.com" <kishon@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Message-ID: <20130906101142.GA29403@sirena.org.uk>
References: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
 <20130823095841.GG25263@sirena.org.uk>
 <522897FD.2030509@nvidia.com>
 <20130905143431.GI8980@lee--X1>
 <52289BD4.9060607@nvidia.com>
 <20130905153432.GD3084@sirena.org.uk>
 <CAF2Aj3j23ZvfAjZe82jo+fz_vD4k-HMby+eirYj_havYsy8wZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <CAF2Aj3j23ZvfAjZe82jo+fz_vD4k-HMby+eirYj_havYsy8wZA@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] regulator: palmas: add support for external control
 of rails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2013 at 10:54:27PM +0100, Lee Jones wrote:
> Would you like to take it instead then Mark?

Yes, now that it's slipped into v3.12 it seems more sensible.

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSKapbAAoJELSic+t+oim9Dl4QAIpekcErk25B+bby9Mt/lqpZ
LlZ7d+bp/UqUcTYtGNbrfqNWrvxN8/hIergNiRm6ryG9DVnXxU1OpZIVL4wdSNif
r/pSjSkj//g8CtZ7fOG5RkN1ugjeTrBy5cVyikMUBRQb48u10zw8kc8kBcHveFO1
PGFVvjqyKj9zUPW3Uf9A+kneDbBal04fGtzcsnS98xmr2atrInsCewcB9znmuLqM
Pt+qfyIwHeqKISroiTyJghFKWBhHs7G74JPN6wFe4U9LmtkIm759RIMf/l5i2ZLF
TVvnOvwTKVoJKfg1IZFdZHkziAXxpqsDLFoNSglm09vCCkKgrJiWpWlIRHYfWX3c
p5NXQCRVjGmTeXnJnbPRmTm09XML51XZ8qhH40Osq+fdR1ks36rjoSOqxTcqFaQ4
l1SSZvTqZ/fdxHA6Th8DlYfSCOz+o+sIPpObwwfnOYC0debC9Uqtn/J1GyOWdP8U
rRpi1sRakxZ9tA0gUZZUV1gCtp/IOhaUypfS88n84fO2AfgfXbI5JqAnngVWypeY
ZWm/s5qJMKcQ+BbnXwmuSuH1q4R+gSLA9MFXD4kGY4fz8MCCKJhrMnKtKPZaNBSW
mkwrySU9c9JYl0KVUt3qYVbJeU/NKlVLOGtfKOGug/r1cW2Ny3/ofhGV5VJXVstY
Jbxf+S4mnIWZi/D6mFdb
=Yb6K
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
