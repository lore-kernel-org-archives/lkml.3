Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3LJTUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:20:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:45093 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3LJTSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:18:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,866,1378882800"; 
   d="asc'?scan'208";a="395608694"
Message-ID: <52A76A03.4040809@linux.intel.com>
Date: Tue, 10 Dec 2013 11:22:43 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: balbi@ti.com
CC: Michal Nazarewicz <mina86@mina86.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu
Subject: Re: [PATCH v7 2/5] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com> <1386633338-10919-3-git-send-email-david.a.cohen@linux.intel.com> <xa1t7gbdfn8c.fsf@mina86.com> <52A68BF7.2080901@linux.intel.com> <20131210044117.GA28252@saruman.home>
In-Reply-To: <20131210044117.GA28252@saruman.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="G657Cm38CrmrdEfGun3weIwOUiAekAWaO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G657Cm38CrmrdEfGun3weIwOUiAekAWaO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>>>>  /**
>>>> + * usb_ep_align_maybe - returns @len aligned to ep's maxpacketsize =
if gadget
>>>> + *	requires quirk_ep_out_aligned_size, otherwise reguens len.
>>>
>>> =E2=80=9Creturns=E2=80=9D
>>
>> I've got no idea how returns became reguens :)
>> But maybe Felipe can fix it when applying?
>=20
> Sure, but you owe me a beer hehe :-)

Just print this e-mail and you can redeem one as soon as you visit
Portland :P

Br, David



--G657Cm38CrmrdEfGun3weIwOUiAekAWaO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQIcBAEBAgAGBQJSp2oDAAoJEGU5KLu7JjjxHsMQAJUrEjfOwpNSJBq2cFXVS1oE
Za3ZzlC37A/cJ+6UKwyJjt7FstZ/e0MBvYqDctucvHxMfJ9mPjzw1AcuE3tB1VOu
Ase3ltnII52KhUOfwbmwKEERH615zXRa+3MJznlN+maTb7tUSQF8XUor09M/pSWv
hgkQ13qFUDVPFxv+R/QZrZGGIZqgFyVaIeZzGJAkzv016qLvHKVSX+r46J56jpPp
AswWkz6Fp8SeA+F5XfFLVcHzSEa2O24oaJ2ERfyGQ2XwEk/fLcGiHMgfYkrtX5o2
rqvatEqolVHJf0ikV3tK+1A48g4Y60vtWkiNV9D3x5Kcgn7QhnWYrjmgAdqdnptB
cPz+urtsW8emJ1zV9MlxOBLdEZXJe3IOPddsr9/mG6esBLV5DiZHniBUwt+JRN8Q
V3mxsj67Xogm2RVcaIQvlwGTABB1jttLuxAHqJm75OkX/y4VuvTL9Y47BdEvDHda
L3APMQIv9bQ1AmHW57GRiUpgi4ainNOSN5T4IW4ijG9MQaM73qxe7JTAYJIYFol+
NOGAMQMIFAVDjFO5STeVY3G3cV06Y900obFJj6g7Km4HRBy1qMqIBbf1AtJSIzwY
nNXj4PJlFy10A8z2eNtTUtvDdqCFfoQlHNTJcnCzyAP28oyYLhFaqsbJfyWI0eWe
ftXJzh8OyLlkfj5U4QYh
=vH9A
-----END PGP SIGNATURE-----

--G657Cm38CrmrdEfGun3weIwOUiAekAWaO--
