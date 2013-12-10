Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3LJTQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:16:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:35865 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab3LJTQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:16:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,866,1378882800"; 
   d="asc'?scan'208";a="326976593"
Message-ID: <52A769BE.4040803@linux.intel.com>
Date: Tue, 10 Dec 2013 11:21:34 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH v7 2/5] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com> <1386633338-10919-3-git-send-email-david.a.cohen@linux.intel.com> <xa1t7gbdfn8c.fsf@mina86.com> <52A68BF7.2080901@linux.intel.com> <xa1ta9g8iwbq.fsf@mina86.com>
In-Reply-To: <xa1ta9g8iwbq.fsf@mina86.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="hOadKu63tsDr72mJaEBPce2JRo4mlWLRA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hOadKu63tsDr72mJaEBPce2JRo4mlWLRA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/10/2013 07:01 AM, Michal Nazarewicz wrote:
> On Tue, Dec 10 2013, David Cohen wrote:
>> I've got no idea how returns became reguens :)
>=20
> The keys are like right next to each other <http://bash.org/?5300>. ;)

I'll remember this excuse if I need some day :)

>=20
>> But maybe Felipe can fix it when applying?
>=20
>=20
>=20



--hOadKu63tsDr72mJaEBPce2JRo4mlWLRA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQIcBAEBAgAGBQJSp2nBAAoJEGU5KLu7JjjxyroP/RTGNlH9CRnYuWdipez559T4
XyNKXWVtQAf+e3m+FQPhHrEi8WAZUFFgs8k8dX761oDfAO/TdwY5RjVXW6OUbIpw
ADG+HN4hKVwqAXnx8mbJ8kYMwlVUSKCmbEkcwe5kMiSrZNzqm+BPBSSpwCb/uDw2
1/xviPrgavJEm4ddcE575DCJvzRSPtltKMUlsOioFKzuwQhSoS1nlbSfSIrSJxSJ
eEGJaJH5Q0gGMZ8ZBofgOIW+NyX7llq09hqE/voOoJCubC4ZKeG4KzgSUDk0oQRu
RzMHS79HBrkLTmIlE36PRjj2QK8IdraUnm1H3gDabTR8cexaAZInYfE7VNAk8VJv
Q3fkdtUxNpq50WyT1LSWMwQDWt3W7t60fRo05s9fUvEJDuHwDMMLDs91vN5qsAtN
A+xXo72SQjLqGMf/gLecAJs2c/clfGDybiHT42A7WdjftMSKktTclHMxlojDnU4d
BXdvCKHPx9aonhDSgpbc2WLWvWoIAtT+fJrcMqrrRLQjJoSP/noPMY9TggumvtVu
35LqM4ELIc+CEddnY22HWMRebwgu2u6CV38yopWtcp6NuEf6ac6QetQV2ckgrY+f
c2/zzh78CtUl1jv9I93hx4D1FW5eQEX96W0Kvg9kvkg+9nyzq96m0V1NV8ykTk4H
KlAOd/WkGWLJp6NrOVri
=ivYG
-----END PGP SIGNATURE-----

--hOadKu63tsDr72mJaEBPce2JRo4mlWLRA--
