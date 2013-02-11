Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab3BKUXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:23:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35741 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab3BKUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:23:17 -0500
Date: Tue, 12 Feb 2013 07:23:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpio: devm_gpio_* support should not depend on
 GPIOLIB
Message-Id: <20130212072314.e956c3ea4d51405ad561418f@canb.auug.org.au>
In-Reply-To: <CACRpkdbT2eAZR2Ud5f9h0TFsA5M0RpysE9SqMgoL-hcB8fS+Ew@mail.gmail.com>
References: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
	<1358495866-9329-1-git-send-email-shawn.guo@linaro.org>
	<CACRpkdZA9O6N7hmtU-6R1Ff6hW5vjD_ar9RLG1dbkd+MWyoKiw@mail.gmail.com>
	<CAMo8BfJ=6WbAHoCpftRHW1iMtG8robyYUEqqCG2SecixDTgC+g@mail.gmail.com>
	<CACRpkdbT2eAZR2Ud5f9h0TFsA5M0RpysE9SqMgoL-hcB8fS+Ew@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Feb_2013_07_23_14_+1100_coy9dIYRfR4b0nf7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2013_07_23_14_+1100_coy9dIYRfR4b0nf7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 11 Feb 2013 15:13:20 +0100 Linus Walleij <linus.walleij@linaro.org>=
 wrote:
>
> Max, can you point us to an xtensa cross-compiler so we can
> figure out where the problem is?

Prebuilt toolchains suitable for building the kernel can be found at
http://www.kernel.org/pub/tools/crosstool/ .

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Feb_2013_07_23_14_+1100_coy9dIYRfR4b0nf7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGVMyAAoJEECxmPOUX5FEqPsP/j1zddaAhdAuLI3IbNXIPEna
T9s6JrzSbo3atFl+z2HcNBEXBAlJDu/lqIEMoKHC1097/eqz+pQVWKc6ikH4a79z
48Z63BoIGV8i+zefvsMM8T/gegrwH47Xn68yeNWFxmkSgP4rVvzq46UprA1RBuiC
VHRq6VgCuYSZBtK9+zLJOQxXOj9MibuylaycGsYF8WBwmQ7SCIv+ETYiZiyC4KuU
gsLSs5Y01W6mhFqwOoF6sra+4ZY7El711f1b2d39AgK8pVbOiEJE53sjtFs9eSY5
MMefGePD09wYpw8Ncq2/XE2tP6oTyIS7emGM8dBgz2ohnZ4VwgH/+EpzNmNiGbYq
XPry+dZjpGu3T+9hWPvPbNCqPI/QI7MQDHNviLo8eRDdOrCRHMz52/rUOZiHWfL1
BGpP8wwzh7rqj2bbocxKo7EwaGexKt+SPr06t0W1kEWohqiNyx9Zf9PLBb6oPfvI
pQsSPpPKxFk3xu9NFo3W2Mer08y03+YG2ahmRDIs5I9ELpReuDNEqcAaXEpkbMHI
+rFHRT2S1vy8t4hHSikLwbOy8PxUNQEQDt0cqvngvxPi+ZBUzyqQ+E5FQJs+JEgJ
TGZgM2uhOt/vbhZabiKugxo3gk+RxBOM0vcvi2NCl0Z6x8fpMjAik76ENE+tBIRv
LIePONJJcTWR9BcRbXX3
=jtLd
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2013_07_23_14_+1100_coy9dIYRfR4b0nf7--
