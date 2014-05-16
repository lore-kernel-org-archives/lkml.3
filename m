Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaEPSiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:38:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:37141 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbaEPSiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:38:21 -0400
Date: Fri, 16 May 2014 20:38:14 +0200
From: Sebastian Reichel <sre@kernel.org>
To: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Status of Power Supply Subsystem
Message-ID: <20140516183812.GA17752@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

It seems the maintainer of the power supply subsystem, Dmitry, has gone missing
in action since about mid-Feburary. I couldn't find any mail from him on the
usual mailinglists, he did not reply to any of my mails and the power supply
subsystem git tree mentioned in the MAINTAINERS file has not been touched since
2014-02-01 [0].

Is there a standard procedure to handle subsystem maintainers, who are missing
in action? I have patches for the power supply subsystem and have seen more
patches from other developers on the mailinglists.

[0] git://git.infradead.org/battery-2.6.git

-- Sebastian

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTdlsUAAoJENju1/PIO/qa51IQAIIuMIG4s0h1eJKkrA40+7xX
y3/h317fuVROeosISHu5qjZ2gx/d/ZCIHph1DVLCyFmw484gQHNEiMP1pj9qoD98
LQBhhpJ6yMIuPMhBdeu7nKFMePpcQfp2agjWSxKUgJz194Ri0gfJbBTAYegJtZX6
cRU1AeMRnSVdqy58RFiYHSAWTIEFnGYPvaD/VTkS0rt8BPaTlzoaTswqrFjCPirm
dTCTc0/TSav0AvK9Z4CC5pNC52goHcu44M/wVLLIsYLHRbc/hgVAbgf3lQoMTXUd
Nj2fvBCScGMpKRiNdIBomXJTfq/CEvfM7mnG6SobOJu2cC7+A+XodAaLh5e3iH5u
RK0tdloo5DpHp0cU++LpeJ2Nids+m9mJHN3CTFY6Sw4aB3fXWCXH+PTwnPK6A1OW
dg45e+WOBeVl0Pdd3ah/QIZQBq5ktSRPsdhVVIapKNUiTq8WvwVLJFGzNAnmRbq1
t4lXKgEmaFFV+ajrR4QlympCeMWM3m5lof14jPzFwHmk6UecZqQBPcUQ7EBQhn57
6kyR0Mh70KJU+s3sG0zqfXgkYF9PzfP1yQduOWgPuMqW0584Mhu5aPTv++zGI4Sy
KmleLjO230wTp6Qh8BSfx7gMXXdFB+4Dt4OGw/aKJNeRguxBdgR/ogLuv+vdK6pW
1iCY1alDKZJ3TRNwYmSH
=3nqy
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
