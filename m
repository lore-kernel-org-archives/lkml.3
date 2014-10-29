Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaJ2AwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:52:00 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33417 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaJ2Av6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:51:58 -0400
Date: Tue, 28 Oct 2014 20:48:23 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 1/2 resend] Thermal:Fix memory leak if occur goto
 unregister
Message-ID: <20141029004821.GA5502@developer>
References: <1414482025-4482-1-git-send-email-yaodongdong@huawei.com>
 <544F4F94.9010804@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <544F4F94.9010804@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 04:11:00PM +0800, Yao Dongdong wrote:
> Hello Eduardo,
>=20
> I'm sorry for that my patches listed below have format problems, so i res=
end them.
>=20
> https://lkml.org/lkml/2014/10/20/85
> https://lkml.org/lkml/2014/10/20/84

No issues. Thanks. I will apply them in my tree.

>=20
> Thanks,
> Yao Dongdong
>=20

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUDlKAAoJEMLUO4d9pOJWBXoIAICXwE6VLPo0c1d51aLYciFi
JxJU7ScK++smY52UjIPEteOyc/HI8QAdHTyf4bswwpywEi9MtQWKfUc7cvzMkiEk
ht0Hn+zODgVEWDH8PFTSz9NoBZ0vFxaaIsFmuDBxewKfql64RWSlZnAsxv7KPizj
NqVxd6UBldO40iKDoxu0AFh0Q8EPQaDSgbkB6uaesMprfE6SKY5skYHazbNgnXYO
ykctjt+Ahd0/8vDd6Kk1LMdKdggIPSPGebJEnlu9py7HjXP76iWbjTEdvCDlG8DH
qB1/mzLS7jLpmc0UInXZU88AuIVqoiqhQfsI/lXxm3WQZBlkdpujH7ZQQFN8UuE=
=X/mX
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
