Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaJ1W7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:59:01 -0400
Received: from ozlabs.org ([103.22.144.67]:59990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaJ1W65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:58:57 -0400
Date: Wed, 29 Oct 2014 09:58:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: linux-next: build failure after merge of the usb-gadget-fixes tree
Message-ID: <20141029095848.12be411e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/IU0DTIM77L__jCCUkbZl/b6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IU0DTIM77L__jCCUkbZl/b6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

After merging the usb-gadget-fixes tree, today's linux-next build
(x86_64 allmodconfig) failed like this:

drivers/usb/dwc2/gadget.c: In function 's3c_hsotg_suspend':
drivers/usb/dwc2/gadget.c:3633:2: error: implicit declaration of function '=
s3c_hsotg_core_disconnect' [-Werror=3Dimplicit-function-declaration]
  s3c_hsotg_core_disconnect(hsotg);
  ^

Caused by commit 9f2104db1295 ("usb: dwc2: gadget: fix calls to phy
control functions in suspend/resume code").

I have used the usb-gadget-fixes tree from next-20141028 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/IU0DTIM77L__jCCUkbZl/b6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUUB+tAAoJEMDTa8Ir7ZwVX28P/2F7cTP4bs8N6hejjVG1n6pu
hAF7HEOsSQ/dVDFUji20tHpFpXpTQntczjpkLg52eRdZQLGlY5QRY8lo5ng7FIQs
rU9d5vueY2LwuP5TQjH7gUkjoUK1ObYujbe4jx8/7+MDTJz2fbxWP23YIGq0JpZS
o3jUz8qrXokXAIv1MJzlmBitR95z6R7ZYJ19pj0REjMac9yUqGTH21iPncd8u3mW
hF5Ecw8MR4Zz01kXeGkOwGlQhpiW83pPAJaqhktZ+3ZSXRRaJD8/Yj6LqKzywAbT
AnSe/H4lCSijPFuenqdQdlwRuLzRREqRr6nSx+eUnDm1346GHurcmcHm0ljG/61R
sR6p8XV9/qVYpAFkfi+RqIe3IImIWXnB3OdsbbAJn67Q0W0NB8Xv6GdCveRMSQxa
KLpZnN/inIm0/fbhNO9aOalLRSx1cz0yjxksdhi5L0l4T4TqPUZLNTlHPnngMlzE
isYokb+ai6JrDQnrmAdF8kVCYv2qtXu6mEIbxhWvX42Xq1vrnIm92mudL0LZe2mc
oRzppnR4l+3JMgLA/Se1hqS+uR+zc3pQM/yron4rL8XlguQoyz4RH669HnSaYvLk
wgImfkoUXfC9e0jNqzzfRFcEmGRJr/gJxVVVZW+scf1X8RiS26RUsCaE1fJqJSmG
4X72N8z9JSbNI3L8Sy9D
=2SKm
-----END PGP SIGNATURE-----

--Sig_/IU0DTIM77L__jCCUkbZl/b6--
