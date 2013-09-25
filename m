Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3IYNY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:24:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43816 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab3IYNY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:24:26 -0400
Date: Wed, 25 Sep 2013 08:23:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Luca Coelho <luca@coelho.fi>
CC: Felipe Balbi <balbi@ti.com>, <ben@decadent.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH] ti-connectivity: add wl1251 firmware and license
Message-ID: <20130925132359.GE10746@radagast>
Reply-To: <balbi@ti.com>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
 <1380107096.4503.8.camel@porter.coelho.fi>
 <1380107278.4503.9.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uCPdOCrL+PnN2Vxy"
Content-Disposition: inline
In-Reply-To: <1380107278.4503.9.camel@porter.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uCPdOCrL+PnN2Vxy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 25, 2013 at 02:07:58PM +0300, Luca Coelho wrote:
> On Wed, 2013-09-25 at 14:04 +0300, Luca Coelho wrote:
> > Hi dude,
> >=20
> > Great, this is cool! Finally! :)
> >=20
> > A few comments...
> >=20
> >=20
> > On Tue, 2013-09-24 at 09:44 -0500, Felipe Balbi wrote:
> > > It's way overdue that we send these firmware
> > > blobs upstream. Thanks for everybody involved
> > > in getting this sorted out.
> > >=20
> > > Cc: Luciano Coelho <luca@coelho.fi>
> > > Cc: Pavel Machek <pavel@denx.de>
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > ---
> >=20
> > The commit message could be a bit more descriptive rather than
> > narrative?
> >=20
> >=20
> > >  ti-connectivity/license-wl1251.txt |  59 +++++++++++++++++++++++++++=
++++++++++
> >=20
> > The license file should be in the root, together with the other licenses
> > and called LICENCE.wl1251 (note the en-GB spelling).  Also, this license
> > is *very* similar to the one for WiLink6/7/8 (LICENCE.ti-connectivity),
> > except for some very minor things and the formatting.  Couldn't the same
> > one be used, for the sake of simplicity and consistency?
> >=20
> >=20
> > >  ti-connectivity/wl1251-fw.bin      | Bin 0 -> 194180 bytes
> > >  ti-connectivity/wl1251-nvs.bin     | Bin 0 -> 752 bytes
> > >  3 files changed, 59 insertions(+)
> > >  create mode 100644 ti-connectivity/license-wl1251.txt
> > >  create mode 100644 ti-connectivity/wl1251-fw.bin
> > >  create mode 100644 ti-connectivity/wl1251-nvs.bin
> >=20
> > When sending big binary blobs, it's generally better to send pull
> > requests instead of patches.  If you add the -p option when calling git
> > pull-request, the text will include all the readable parts but will omit
> > the binary stuff.
> >=20
> > Thank you very much for following up on this!
>=20
> Ah, and I forgot to say that you should update the WHENCE file
> accordingly too.  Check the wl12xx and wl18xx drivers for examples.

I'll send a pull request, but how about this ? I don't think we can
change the license. It seems like the other firmwares are using the
older license, I'd argue those should be changed to the new one, but
that's another discussion.

commit 453b2a32470b2e50c5c96bc7ac4a39a3f6b6b30d
Author: Felipe Balbi <balbi@ti.com>
Date:   Tue Sep 24 09:29:34 2013 -0500

    ti-connectivity: add wl1251 firmware and license
   =20
    This new firmware blob is used with the old wl1251
    device whose driver has been in the kernel for quite
    some time.
   =20
    Cc: Luciano Coelho <luca@coelho.fi>
    Cc: Pavel Machek <pavel@denx.de>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

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
index e66fea5..4e9e2ed 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1705,6 +1705,19 @@ Licence: Redistributable. See LICENCE.tda7706-firmwa=
re.txt for details.
=20
 --------------------------------------------------------------------------
=20
+Driver: wl1251 - Texas Instruments 802.11 WLAN driver for WiLink4 chips
+
+File: ti-connectivity/wl1251-fw.bin
+File: ti-connectivity/wl1251-nvs.bin
+
+Licence: See LICENCE.wl1251 for details.
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

--uCPdOCrL+PnN2Vxy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQuPvAAoJEIaOsuA1yqREmeUQAIrnSNCrz/V/blgtSsuWSMel
4vIMo4r6sfZjHAea3xIXoPYpiKdbxsVQDlhE4oanuVsRGEDEup8DMyDdH3MCG04H
UxpmcYQczHXXB7nCWv75lgXLBXIccFjROXOKrIU7i+HuCwKvXaf79o0MzBGULB2C
/f+s/1p8irVxc5Bl+B2L6a2lX/iiMMhpe33XeP4G4u05474nEZ71bZd8QoNfiRYJ
4y0+ksV/9Ei8UJflUHF26FIE64vvI0TFGPxHIrv9jPMTssqnuSC4Uw4T/waace6o
vPu5rIaFMtIvl+LqdIbaNtfDvV4ZxYlE8RrHSO7U0niWjFGtNHmnZcT8pE4IgVbm
STRF8LXuOzNYH5yI4J2ALwVPrrrdfumSLGNIGwZpsvezei1HU+LyFuhmVMgdDQ4H
j82ptwCWpKGB01TJfoqymrpdkIu5oNSOLg1RY5/nCHAi5ycRCh0PAh+HkWeQImR2
aUAfaBps0LFvx5/WaBogs7+03E2WplGVl3eSlZLMJSavxQD+f0PG3Vm2XwE5B/pT
b3szwEsR3vP3/PTNYLeDthp5xqAPASLrtyE8uWFnmCkkdODsaEVL7BWin01EUzHr
A7M33PzCL297S/LpVfbB6SKSDMTI00nxsx7sta+1UThPAT/OVHYhMfl3LVVkLBug
IcJwN7KXmGTNJLqHgMqG
=sDne
-----END PGP SIGNATURE-----

--uCPdOCrL+PnN2Vxy--
