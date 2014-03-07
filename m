Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaCGR36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:29:58 -0500
Received: from sauhun.de ([89.238.76.85]:55464 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbaCGR35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:29:57 -0500
Date: Fri, 7 Mar 2014 18:29:49 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
Message-ID: <20140307172949.GL28943@katana>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140307160836.GM21483@n2100.arm.linux.org.uk>
 <20140307171932.GU607@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xjamM5M9kpPM/bcu"
Content-Disposition: inline
In-Reply-To: <20140307171932.GU607@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xjamM5M9kpPM/bcu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Another question is... why do we need to check pd->dev.of_node here?
> > If CONFIG_RESET_CONTROLLER is set, we always try to get the reset
> > controller node, so drv_data->rstc is either going to be a valid
> > pointer, or it's going to be an error pointer - neither
> > reset_control_get() nor devm_reset_control_get return NULL.
>=20
> Hmmm, right. I'll fix this in a later version.
>=20
> Wolfram, do you want me to respin the patch making use of
> reset_get_optional introduced by Philip in its other mail?

I think I'd prefer both issues fixed with one patch like in "fixing up
reset controller handling".

And you might want to give a Tested- or Reviewed-by tag to Philipp's
patch if you are going to use it.


--xjamM5M9kpPM/bcu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTGgINAAoJEBQN5MwUoCm2BNYP/RDKi/NN9cXVrxTXi/wtuXU6
acD/7rFzVmF/C+uGEnYTx8Gck5R/um1WG/p9XXxms5D4zfeXqlzwJDuYHAXaR8pm
onlfPvQ3I4rFkD/wLl4nmpJGSs2CO23xZbSSvZFMBX4e8ckMNBkT5QHEE50Zsz/H
Gg/Kp3ykLcYK2QQKJZ5qHRMyGgCESi1/cYcWQFKO4GSNCiyboP+uDyTS7cHmEczx
awuG1U9A66Jnhak51LonOWKMDPvYwUC+GG8BFe32DzxTbWQTLkNHhDoOTI+NRXtr
Kzp6bYvyhbzLXpZrMeOr+hr9SRgvA2WF0zrRimYQsMfQA6rVU7Wmhty3ycKfXXw7
PyBRpG9fgrnDB9mePhWmzuectsizdgwxkWnlhULvXuRdEsdW+ZyIr5XGeszVJ1Cf
nCMTBd0ADdShsIJJ8XyaPtL65nVQ8t2BaRmBU6FyCIIyswiiFaQZ9VWFtEAvY2Wz
wGmU6F+NpB8iFZFdnWLW6J4cU5hxrqlisuQH7LRvhh2guSekpWAEHTFpeI1gfpIm
RSKeu6flBtuXz2nBLTnoxy7jj6AZ3Yykto4jveNED4hVB34jaD4Z+BPkT4ng/BBr
jpoNODuySLROhFglyExTLaLn4fkCNutJBaItwQvW+UzxpcljM/VMuCJucA/YHpDO
2z9QVJJZqX+Ralypdrye
=V+vU
-----END PGP SIGNATURE-----

--xjamM5M9kpPM/bcu--
