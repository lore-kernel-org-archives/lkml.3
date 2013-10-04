Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3JDPdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:33:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41167 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab3JDPdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:33:35 -0400
Date: Fri, 4 Oct 2013 10:32:46 -0500
From: Felipe Balbi <balbi@ti.com>
To: Luca Coelho <luca@coelho.fi>
CC: <balbi@ti.com>, <dwmw2@infradead.org>, <ben@decadent.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, Pavel Machek <pavel@denx.de>
Subject: Re: [GIT PULL] firmware: wl1251 firmware binary
Message-ID: <20131004153246.GJ16059@radagast>
Reply-To: <balbi@ti.com>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
 <1380107096.4503.8.camel@porter.coelho.fi>
 <1380107278.4503.9.camel@porter.coelho.fi>
 <20130925132359.GE10746@radagast>
 <1380116535.4503.19.camel@porter.coelho.fi>
 <20130925135943.GI10746@radagast>
 <20131002125535.GL1476@radagast>
 <1380862901.4265.33.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWOmaDnDlrCGjNh4"
Content-Disposition: inline
In-Reply-To: <1380862901.4265.33.camel@porter.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pWOmaDnDlrCGjNh4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 04, 2013 at 08:01:41AM +0300, Luca Coelho wrote:
> Hi Felipe,
>=20
> On Wed, 2013-10-02 at 07:55 -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > here's a pull request for wl4 firmware. I'll send a patch for wl1251
> > driver updating firmware load path.
> >=20
> > The following changes since commit b8ac7c7e27dcd13fa3c843aaf62457e9c57e=
a4db:
> >=20
> >   linux-firmware: Add Brocade FC/FCOE Adapter firmware files (2013-09-3=
0 04:53:32 +0100)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/linux-firmware.gi=
t wilink4
> >=20
> > for you to fetch changes up to d726804dbc8dad88587b6be17716714cd91ed86c:
> >=20
> >   ti-connectivity: add wl1251 firmware and license (2013-10-02 06:55:39=
 -0500)
> >=20
> > ----------------------------------------------------------------
> > Felipe Balbi (1):
> >       ti-connectivity: add wl1251 firmware and license
> >=20
> >  LICENCE.wl1251                 |  59 +++++++++++++++++++++++++++++++++=
++++++++
> >  WHENCE                         |  18 +++++++++++++
> >  ti-connectivity/wl1251-fw.bin  | Bin 0 -> 194180 bytes
> >  ti-connectivity/wl1251-nvs.bin | Bin 0 -> 752 bytes
> >  4 files changed, 77 insertions(+)
> >  create mode 100644 LICENCE.wl1251
> >  create mode 100644 ti-connectivity/wl1251-fw.bin
> >  create mode 100644 ti-connectivity/wl1251-nvs.bin
>=20
> Since you didn't send v2 of the patch, you could have used the -p option
> with git request-pull so we could see the changes you made here...

diff --git a/LICENCE.wl1251 b/LICENCE.wl1251
new file mode 100644
index 0000000..bd0f5f1
--- /dev/null
+++ b/LICENCE.wl1251
@@ -0,0 +1,59 @@
+Copyright (c) 2000 =E2=80=93 2013 Texas Instruments Incorporated
+
+All rights reserved not granted herein.
+
+Limited License.
+
+Texas Instruments Incorporated grants a world-wide, royalty-free, non-excl=
usive
+license under copyrights and patents it now or hereafter owns or controls =
to
+make, have made, use, import, offer to sell and sell ("Utilize") this soft=
ware
+subject to the terms herein.  With respect to the foregoing patent license,
+such license is granted  solely to the extent that any such patent is nece=
ssary
+to Utilize the software alone.  The patent license shall not apply to any
+combinations which include this software, other than combinations with dev=
ices
+manufactured by or for TI (=E2=80=9CTI Devices=E2=80=9D).  No hardware pat=
ent is licensed
+hereunder.
+
+Redistributions must preserve existing copyright notices and reproduce this
+license (including the above copyright notice and the disclaimer and (if
+applicable) source code license limitations below) in the documentation an=
d/or
+other materials provided with the distribution
+
+Redistribution and use in binary form, without modification, are permitted
+provided that the following conditions are met:
+
+*	No reverse engineering, decompilation, or disassembly of this software
+	is permitted with respect to any software provided in binary form.
+
+*	any redistribution and use are licensed by TI for use only with TI
+	Devices.
+
+*	Nothing shall obligate TI to provide you with source code for the
+	software licensed and provided to you in object code.
+
+If software source code is provided to you, modification and redistributio=
n of
+the source code are permitted provided that the following conditions are m=
et:
+
+*	any redistribution and use of the source code, including any resulting
+	derivative works, are licensed by TI for use only with TI Devices.
+
+*	any redistribution and use of any object code compiled from the source
+	code and any resulting derivative works, are licensed by TI for use
+	only with TI Devices.
+
+Neither the name of Texas Instruments Incorporated nor the names of its
+suppliers may be used to endorse or promote products derived from this sof=
tware
+without specific prior written permission.
+
+DISCLAIMER.
+
+THIS SOFTWARE IS PROVIDED BY TI AND TI=E2=80=99S LICENSORS "AS IS" AND ANY=
 EXPRESS OR
+IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES =
OF
+MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
+EVENT SHALL TI AND TI=E2=80=99S LICENSORS BE LIABLE FOR ANY DIRECT, INDIRE=
CT,
+INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT N=
OT
+LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA=
, OR
+PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLI=
GENCE
+OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
diff --git a/WHENCE b/WHENCE
index aac3ba9..3a35670 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1712,6 +1712,24 @@ Licence: Redistributable. See LICENCE.tda7706-firmwa=
re.txt for details.
=20
 --------------------------------------------------------------------------
=20
+Driver: wl1251 - Texas Instruments 802.11 WLAN driver for WiLink4 chips
+
+File: ti-connectivity/wl1251-fw.bin
+Version: 4.0.4.3.7
+
+File: ti-connectivity/wl1251-nvs.bin
+
+Licence: See LICENCE.wl1251 for details.
+
+The published NVS files are for testing only.  Every device needs to
+have a unique NVS which is properly calibrated for best results.
+
+The driver expects to find the firmwares under a ti-connectivity subdirect=
ory.
+So if your system looks for firmwares in /lib/firmware, the firmwares for
+wl12xx chips must be located in /lib/firmware/ti-connectivity/.
+
+--------------------------------------------------------------------------
+
 Driver: wl12xx - Texas Instruments 802.11 WLAN driver for WiLink6/7 chips
=20
 File: ti-connectivity/wl1271-fw.bin
diff --git a/ti-connectivity/wl1251-fw.bin b/ti-connectivity/wl1251-fw.bin
new file mode 100644
index 0000000..f89c983
Binary files /dev/null and b/ti-connectivity/wl1251-fw.bin differ
diff --git a/ti-connectivity/wl1251-nvs.bin b/ti-connectivity/wl1251-nvs.bin
new file mode 100644
index 0000000..2bf9c50
Binary files /dev/null and b/ti-connectivity/wl1251-nvs.bin differ

--=20
balbi

--pWOmaDnDlrCGjNh4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSTt+eAAoJEIaOsuA1yqREUdIP/ivhhMqK0Dk/+/uWDsGw8vX5
UTJqf9tObxRQjtwPqfMUKs3VwF/0Hsq1NSsYqf/3bApbEMss4dGdN+uKRNeig+9D
SPG62Fts4R5dmDYwd1ccA6YOjFZAGC1K6Vcci038sNBEdLL8LCz2YlyIdJL2jA4e
N4SSXhr0HQ/XBDqHyMdQbyGBiNckPaGVgSnfYtpoYa+oN89kzah2zxW/XsQYVRsN
PDs7JnMqoBpu+a94Vvnl3MqB8ISvSVbkLtTvCtVZ/zFNuh/+0SaT3ZSVd2gbPANy
aQ+LH9yXcGRLpKCEVifC8EKScfyAeVk59iOp+Iqrz2jbxY2pg3dTrnkYUEXesD+P
B9fHPOU+OXghp6WkUrucrlQm/RRJ8YFFYppI14pgOQUWvNO3SWH69j48QASq8Ep+
H5H8aetobGKYgK1ObXQNTeKsybMjb/rZa8jC2Qz9QqnuPKxsuLA1J3lpl/R12L/n
XCAUf+8yuu/RFvkFlTnNEiEmnmpu0H80J/U6za300BGrLZbMGucAu/t5FhYMhbMd
CSMx8ksPFglKQ5mzHP1pmOfopHUDtIAoL4kflPrhWda7/Ba6d/yvo7IRbRm704al
iTKeTMKak2GGM5R5XWQE5fywAlPuTvI+4ZWQH56aOY8vQicuXsoA7MykvhXJWnl1
gjmEDIlry+R4mXxyVTC4
=L/Te
-----END PGP SIGNATURE-----

--pWOmaDnDlrCGjNh4--
