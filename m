Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaCCKpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:45:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49523 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaCCKpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:45:30 -0500
Message-ID: <53145D42.9080806@ti.com>
Date: Mon, 3 Mar 2014 12:45:22 +0200
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
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>	<53145591.4070004@ti.com> <CANq1E4QJqB0CSNeSh2jsp90ZtcLwFwfSG=qjodSLdV_aGbL3BQ@mail.gmail.com>
In-Reply-To: <CANq1E4QJqB0CSNeSh2jsp90ZtcLwFwfSG=qjodSLdV_aGbL3BQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="TqVtlUqnI6lMMPVvdPAPxFWfwQIN8FjR1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TqVtlUqnI6lMMPVvdPAPxFWfwQIN8FjR1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/03/14 12:29, David Herrmann wrote:

>> What's the status with this one? Headed for 3.15?
>>
>> Are the SimpleDRM and sysfb linked somehow? (I.e. do they need to be i=
n
>> the same series?)
>>
>> And jfyi, the drivers/video/ changes will conflict with the
>> drivers/video/ directory reorganization series, which may be merged fo=
r
>> 3.15.
>=20
> If simpledrm is included, then the series needs to be applied as a
> whole. As Dave considered merging this for 3.15, I'd appreciate it if
> you could ACK the fbdev related patches (they're really small!):
>   fbdev: efifb: add dev->remove() callback
>   fbdev: vesafb: add dev->remove() callback

Those look fine.

I'm not familiar with x86 fb, so I can't comment much to the series, but
what worries me more is the "[PATCH 06/11] video: sysfb: add generic
firmware-fb interface", which adds new stuff into drivers/video/. No
problem as such, but as said, it'll conflict with the fbdev reorg patches=
=2E

So, presuming nobody shoots down the fbdev reorg series, I'd like to
have all fbdev patches going through the fbdev tree for 3.15, so that I
can handle the (possibly messy) conflicts.

What do you think, would it be possible to keep the sysfb stuff in
arch/x86, and still be able to do the rest of the stuff here? And then
move the sysfs from arch/x86 to drivers/video later?

 Tomi



--TqVtlUqnI6lMMPVvdPAPxFWfwQIN8FjR1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFF1CAAoJEPo9qoy8lh71MvIP/Rg9GiCdBSKyfxeSKJrq9WOv
m/DY+BNgALAz17/nIBC4EsS3QpcY8b0Xk3+3NZHQv74SZLCFz0HstJCVaFxibdyM
UyCZtoSrfMy6n6I/CsY1w19DghQQdzKjzv4TOjzAB+g5TngPl9e0+jczWSgn/3EY
yMKwkYYtqhmNOoQtQ0xeBn1vv9nOhZSPFCjDE3qtMuoGINo8thtJsD26X4zzp8pE
w8ySzwMzylelvDJeEnWo2lwsIKgAE1NJxabyMfjum7mxXokHeQE82BeiW49NvX+P
NE40SVO4gF6TPJe4rhLYmfnyTG/+bzqGTY5KmrwyMqFnO3joJgogHAtonoWvOvjB
qM4Sj+kkTpKg72WZbklygkZoWw9acUg4WBfI63hxoJuXo7r5TKTGOT+zHlwWWnyN
MirqIw/NZdDgRKI4ReL6SM0WBA9TIZobYuKFzYyuaNC1OB0vOmFFEp0MQh0fzvsl
Q8KsuP+vcDl+HyAecuWlz/pVw2GX+mzPMfaxPj03hBEupPqgFvZ5YiNpZTgYKuGR
jrrzRKMXLEtpqyeA8X8q/91Le3Ihk+shjN8+D+jBYy0BCCVZkApfom4U6MsHyXt5
xqM2zBxWw/Gnmn3g8IFy3yhSAHgI08mf817YaOdrNkEqZOUMJhop3ZdayZmyE7bq
jPvTFfnpU/s3Y0CXiplS
=efnW
-----END PGP SIGNATURE-----

--TqVtlUqnI6lMMPVvdPAPxFWfwQIN8FjR1--
