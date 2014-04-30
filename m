Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbaD3Ihn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:37:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45459 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaD3Ihl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:37:41 -0400
Message-ID: <5360B646.6070208@ti.com>
Date: Wed, 30 Apr 2014 11:37:26 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Richard Weinberger <richard@nod.at>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] video: mmp: Remove references to CPU_MMP3
References: <1397561044.1985.47.camel@x220>
In-Reply-To: <1397561044.1985.47.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bs5kbLTL7pWQpU80hAa7Ocmi3mpE9XRxD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bs5kbLTL7pWQpU80hAa7Ocmi3mpE9XRxD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 15/04/14 14:24, Paul Bolle wrote:
> From: Richard Weinberger <richard@nod.at>
>=20
> References to the Kconfig symbol CPU_MMP3 were added to the tree since
> v3.6. But that Kconfig symbol has never been part of the tree. So get
> rid of these references.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, queued this and the 2/2 patch for 3.16.

 Tomi



--bs5kbLTL7pWQpU80hAa7Ocmi3mpE9XRxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYLZGAAoJEPo9qoy8lh71xb8QAIiFgaj7AZacQLg9sF/lJyGZ
uDT0Wkchg4hsDF9NahSmXOd8E337E9wYQfsqeyNE9B4ZCLPJUqZx4PXKF6A76dCk
m2ho0Xau2HdqJtXuuY7kp05o6q5WMG0TktRrnS7V6lCMgl81M0V3e0Rd3RaQt9El
P/UuLmtyY63hbqjzgRl71XG28kZqhtvwHAZin9+R7kPe1w1TO/h2J4LUmPkrUzgT
OP+/aFTiClqddiFJowOmM4dTJxpWe43LCiYmERwnyQ71IxJ4OgJqRiTv2s5tjnkG
68yj/FzgXBXgoLQ1uAHHphlJ8cHA5g5oVBQ101kxWVSExBqeKkMnxFlrKbxAjXFN
sg5BMTwZxwqo0bDvxODchZQzIqNZAhZ8hLPbHxGN69Y0/Clw7quT6fh+oUi0U/WM
xHw4t9Tp/DoGKJl1QoxIe8mY60FKsINPFwZhuL90iHwBkPs6fN7UbgYCPKVBpBl8
tdUc50jOFZG6IC7SEU6Xy01NPU/cHnBqVnHCfC15FiYKbp/oeNuIvdvMSiCV7mEw
M5k2hbhje3cg0iHTzwgbn/tEnZNMNdrUWr1EfLD8opTdcw1RJ33IBA9gu6wEnCQR
34XqqloteijddR0zxnaZxE4yOaEWnkWgomNRAZUgWY8Y/RZLQBpPH2gRIqJ+poFR
4maBJeisc55GvD9Myh1g
=+IGp
-----END PGP SIGNATURE-----

--bs5kbLTL7pWQpU80hAa7Ocmi3mpE9XRxD--
