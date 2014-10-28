Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaJ1AJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:09:07 -0400
Received: from ozlabs.org ([103.22.144.67]:34080 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbaJ1AJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:09:06 -0400
Date: Tue, 28 Oct 2014 11:08:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error fetching the cris tree
Message-ID: <20141028110857.06bfae62@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XaWo6hJ/fO9XRIt7h6jAn0u"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XaWo6hJ/fO9XRIt7h6jAn0u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jesper,

Fetching the cris tree (git://www.jni.nu/cris.git#for-next) this
morning produced this error:

fatal: Couldn't find remote ref refs/heads/for-next

I will use the cris tree from yesterday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/XaWo6hJ/fO9XRIt7h6jAn0u
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUTt6eAAoJEMDTa8Ir7ZwV+GgP/10EwocjZCm1l2hqh9PeYCdc
OZDjTo0ZhqS8lfK0vjbcL/GP5R93oYbxmdxxK/K4tLTc5CMBu+afNri3hGxk0N/Y
X1bGwi4ON3anaZxBbCGfkm6kaPvDit86B0nhaOXlfyEtlfZekJv5PpmtKnq23C1v
d6siRspbIlmqpG9IvCPUZxZ32GwUAu1fJYP0x5EMygj4tu9r5FE+daE1qC4Y1r4Z
Gj2FBNM4s+FNdiyTIIZy1c4mpDC4kC8wZILSGzDRpEDcZok34r/V3tqqFGjZZFAx
TXl1fMQYp383+OgVzUstLwls1OjJiwxoyr0KmC+5HPHGtQq7Rk0OWumNn5tNto1B
i0Dme3wv5heykHK0g3xPiLsynRaF3HiIz54GuzhZNYs4go+v1jQJhZq7yUop2GvT
HCpRRartPmB/h8Bwkrs7CEqPROFEG8tjm4uyizijwlQqEZ7eruciV/tx4F4CH2+y
l4lEVrEH5gyfc0TsF3DsTs/28YuSfQrB12wrDzsa1wvg2LOo0QStpb191yYw4Ve5
Oi24g50IEalk320Feu3iwk/BRQHpiXi7+QiGx8yT35K7NnsbJRYnbjD46y0d2VFd
oV3egjlmRXd4DS45LpdB8MulHJly+QuuJB+RJNwYXwql4nCkd7kV75/JOCaF2ONV
N2Hkq7C7wVrir9uyV2zi
=vT52
-----END PGP SIGNATURE-----

--Sig_/XaWo6hJ/fO9XRIt7h6jAn0u--
