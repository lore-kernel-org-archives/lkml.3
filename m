Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaHWJ5h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 05:57:37 -0400
Received: from azrael.mastersword.de ([5.9.54.215]:53742 "EHLO
	mail.mastersword.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaHWJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 05:57:35 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Aug 2014 05:57:34 EDT
Message-ID: <1408787426.28950.41.camel@redi7>
Subject: Re: [PATCH] bluetooth: hci_ldisc: fix deadlock condition
From: Tim Niemeyer <tim.niemeyer@mastersword.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tim Niemeyer <tim.niemeyer@corscience.de>, Felipe Balbi <balbi@ti.com>,
        stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, jslaby@suse.cz,
        grant.likely@linaro.org, linux-bluetooth@vger.kernel.org,
        andreas@biessmann.de
Date: Sat, 23 Aug 2014 11:50:26 +0200
In-Reply-To: <20140822155140.GA18880@kroah.com>
References: <1398265117-11793-2-git-send-email-balbi@ti.com>
	 <1408715107-21299-1-git-send-email-tim.niemeyer@corscience.de>
	 <20140822155140.GA18880@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Tl0AkOFJRvT8Gx8qyy+w"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Tl0AkOFJRvT8Gx8qyy+w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

Am Freitag, den 22.08.2014, 10:51 -0500 schrieb Greg KH:
> On Fri, Aug 22, 2014 at 03:45:07PM +0200, Tim Niemeyer wrote:
> > This Patch was applied to 3.10 and 3.2. It's probably missed on 3.4.
>=20
> Does it apply there?
The original patch applies not cleanly on 3.4. The init_work is not
available there.

I backported it and it's the same result as the backport from Andreas.
He tested the patch on 3.4.87. The attached patch of my last mail
applies.

> What is the git id of the commit?
Sorry, missed it:

commit da64c27d3c93ee9f89956b9de86c4127eb244494 upstream
commit a22d29e6e5757b1daed7d0b409a815eb33f66e4e stable-3.10
commit 87520218746b8d973670e37237666f174590898c stable-3.2

Tim

--=-Tl0AkOFJRvT8Gx8qyy+w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJT+GPiAAoJELKJ8occyPNxgo0P/0UGwmyZZmxPcIAU7y96257D
onr4hDttLeCd0gS20/x2oUS8XIugbNNjWsz0TNalhTb6DHdOM1cKchyXyd0sgwgP
aRBzoIpEn47csBNK6illq+poTFy9FKguy3f7B6t/ho+gva1ljr5W8UB+emXuEVL0
ioALxyvXIzLxZKuenqcdjToLTI+/L2Wmr+G/Hh2S4L1rh29NwJcU0KzLprFKcLUn
1Hedwnf0rCasLfSGq2z6OVUC9vLZ+CAjtXy8RlAbiUb+61adgKcdpRgc1tkae4E0
u7VqHNd3IV285mBgbjUi/DpILntKmbeQaLxFyQ/tdpC8tWpgBgsXcT7pm8oCBf67
z41s1y1F6pR+iaGYyeQ20qV9IbR/6T0f0i2R1m5p/BQ7+0bHtjb0fowvqtICAAbp
PmiOHzeZNvDJR/2QR4XiisCeZPdKpfCOixVruMN7ztcal4YD3D08vM0DFlK2/P8N
7zhFxKGPY/aarm+QzIMwlFIPeK987P4bwvyAUpFqg/gJjdvwcoKgsCrl3VY/rd8f
7MqCzVcD3kUWjldjTotdIc8wX+TeBol2hnQvVvP0+2dlxljHTS7YpyfLnWik490c
sBUwUL/LNfBI2Orp2Ro4ubikygqH/9lkGuwHXEzPoHFtwxB+QIu/X0AVqb50M1v0
18LmXnmibepPVmlYH3CJ
=wVoQ
-----END PGP SIGNATURE-----

--=-Tl0AkOFJRvT8Gx8qyy+w--

