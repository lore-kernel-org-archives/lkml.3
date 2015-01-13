Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbbAMEDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 23:03:05 -0500
Received: from ozlabs.org ([103.22.144.67]:40646 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbbAMEDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 23:03:02 -0500
Date: Tue, 13 Jan 2015 15:02:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-ID: <20150113150255.619953f5@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zAck5_Nve5_mh9f8+r1Nun/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zAck5_Nve5_mh9f8+r1Nun/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/dwc2/gadget.c between commit 62f4f0651ce8 ("usb: dwc2:
gadget: kill requests with 'force' in s3c_hsotg_udc_stop()") from the
usb.current tree and commit 6b448af46e2a ("drivers: usb: dwc2: remove
'force' parameter from kill_all_requests()") from the usb-gadget tree.

I fixed it up (I used the latter version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/zAck5_Nve5_mh9f8+r1Nun/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUtJjzAAoJEMDTa8Ir7ZwV9ZIQAIWImXnkz2OihboLYEYSLpKV
WBK+OZ9rWH1FSsU9c+RXVPBLZdpU+pgvHxzkIvE0t4J4sy3AVCkHu7sZ4GeETKgn
EoHEV9ODC+146KZFzhjkhkrDx/RpJLKjVeT+XAVx0I38kjFWPJv7MA7bwzxr+R3+
eiSGtskniFICdid7clfIErvF53LoT0Hzj4ffPRzrCfSV4hZ084zvaop/Gs+tcmbj
AgCZ/VEeWmd16nQlL5G/AHmRMYcJsBk/EXwK3JBopP8E0X4+hfywWedqw2MN6mLu
ngzbjIrRHfUIJAMZMocUqrY9WZQ51JLY17vemtyPdRDYnbncEQJRgsWPCTKHswUD
VftJ4lo1seHbrfFEAaMNkht20lLarnREvTO5Bf5AQ8AsXGCcRqDv/6XBcRN1zAPL
oRTw0GduxjLZe2Rt5RRGs/H/6SzPHQ0uVMe6A1erODT2lAoY9++VAeCxZSNrg3DF
7pj5xqlcI3kxogphRUZdBTaMJIU445hgSNbiSNlVx9Q/39ds/t1QuEMbg0BedgjZ
N5Th3pDDwZMK//KHFpvelsBeFInbn6Shh6ry40vEN5qskPM3f6DJtWw2lTM5Gxmi
NxV+wMo0w1Ybu0E/5KTguV5rJxtJVKGuPLBmN+toEi2qN+boq1gr1gOW+KbIpcum
0LLV1cCf9dSLlrNC+EQz
=kZ5e
-----END PGP SIGNATURE-----

--Sig_/zAck5_Nve5_mh9f8+r1Nun/--
