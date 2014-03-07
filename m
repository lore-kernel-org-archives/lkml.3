Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaCGNwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:52:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60896 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaCGNwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:52:44 -0500
Message-ID: <5319CF23.6090103@ti.com>
Date: Fri, 7 Mar 2014 15:52:35 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 00/11] SimpleDRM & Sysfb
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>	<53145591.4070004@ti.com>	<CANq1E4QJqB0CSNeSh2jsp90ZtcLwFwfSG=qjodSLdV_aGbL3BQ@mail.gmail.com>	<53145D42.9080806@ti.com>	<CANq1E4QYuMsj3W80jiyOfeYr+Xm=J096idyvgCUpFhADWR1ZvA@mail.gmail.com>	<531465FF.1000201@ti.com>	<CANq1E4TmACNwyANaUsWufJL1ne4pk4Gv+g4y7b6xeO=Po-SN9g@mail.gmail.com>	<5319BF40.70305@ti.com> <CANq1E4QXWYQE5DWOA7F39oHFd2ZnV5Ny4ykOw1=aJT+B_umy3Q@mail.gmail.com>
In-Reply-To: <CANq1E4QXWYQE5DWOA7F39oHFd2ZnV5Ny4ykOw1=aJT+B_umy3Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="CdwFsgc4IPDu6rpKrTopFN1dNLA5D2Pj2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CdwFsgc4IPDu6rpKrTopFN1dNLA5D2Pj2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/03/14 15:05, David Herrmann wrote:

> If you can take these two patches, that's fine. They're not strictly
> needed by the series and I'd be happy to see them upstream. The other
> sysfb patches should be merged together, so I don't think there's much
> gain in applying them through fbdev.

Ok, I've applied them to fbdev tree.

> The DRM tree is usually merged late, anyway, so I'll see whether we
> will merge simpledrm through drm-next or not. If not, it'll be 3.16
> then. If you can get the fbdev merge in early, that should be enough
> for us to figure it out and provide a conflict-resolution. Btw., do
> you want the generic sysfb-helper in drivers/video/ or
> driver/video/fbdev? It's not limited to fbdev, so I'd put it in
> drivers/video/.

With a quick glance, it doesn't seem to depend on fbdev in any way,
right? That makes me think drivers/video/.

 Tomi



--CdwFsgc4IPDu6rpKrTopFN1dNLA5D2Pj2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGc8jAAoJEPo9qoy8lh7162UP/0T+5IVdqW1w3zSVDEfhUVRK
n88ZgrS7hgUlqlj8z/NM12bRukQMgOHarFLDKs1tSlWgR5LtMQMU6oqgujjS5R9t
4PV8yNhUGo4xo7wlZYJLe04jEBQXNmfovX1RSegpYZYgCoPipooQ/s4wVTflcD4f
FiatPYwyx+I9cnTuDw8YxBefb5Pvaii3Kd/QiUphSLlw4slN/mLl0p1lCFZd3dBu
VYbncfWBO6MdCJScOAhMmamuibIHZ2XHvwRt87cOOMr8X6tfKurAZrLzeqeYpKf2
AEUVzKAEG3KMn/5VyMzfZyF5tK6qKNrwaB7CigssZoiutOmyHbc7Z2pN2pSV6VAR
czb68mRze1BMKnC3qHIz0tqjbf7G12gRaihbWYwJ8zpeY0l0Fo8pkd3WClDVs89+
Jh9/bhwImEqb5ibExtPC49cX1rO485UTNrRZv/r7rnC21NY/JhrzaFzJ+MK33aB1
dNKEYjjoGPgyMFuxK6FKFDG6LhDI7rDZRbp0AyZnmHRKuU+5l+YvjB1jlLhi6yIl
MgZlfQodP516yljgkAZt23tJg5/3NSbOEff9aE/8bbNTAgcKUVwgs5B9bWudMAiC
a/V771UX2jDbRBITtjlCns2uGcCdIBVTcrzhUFRUnre7CvpwFtLJc8uWCzEdR01p
7nv0HtDiILAtIrbLZX4f
=Kh2Q
-----END PGP SIGNATURE-----

--CdwFsgc4IPDu6rpKrTopFN1dNLA5D2Pj2--
