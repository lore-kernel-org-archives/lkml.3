Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaDYCD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 22:03:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33966 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbaDYCDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 22:03:22 -0400
Message-ID: <1398391392.7767.181.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.8 068/133] [SCSI] fix our current target reap
 infrastructure
From: Ben Hutchings <ben@decadent.org.uk>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        James Bottomley <JBottomley@Parallels.com>
Date: Fri, 25 Apr 2014 03:03:12 +0100
In-Reply-To: <1398197671-12786-69-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
	 <1398197671-12786-69-git-send-email-kamal@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-7AO4cRdaB7Tr0PF0h9nO"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7AO4cRdaB7Tr0PF0h9nO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-04-22 at 13:13 -0700, Kamal Mostafa wrote:
> 3.8.13.22 -stable review patch.  If anyone has any objections, please let=
 me know.
>=20
> ------------------
>=20
> From: James Bottomley <JBottomley@Parallels.com>
>=20
> commit e63ed0d7a98014fdfc2cfeb3f6dada313dcabb59 upstream.
>=20
> This patch eliminates the reap_ref and replaces it with a proper kref.
> On last put of this kref, the target is removed from visibility in
> sysfs.  The final call to scsi_target_reap() for the device is done from
> __scsi_remove_device() and only if the device was made visible.  This
> ensures that the target disappears as soon as the last device is gone
> rather than waiting until final release of the device (which is often
> too long).
>=20
> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
[...]

This and the next patch had the comment "delay backport by 2 months for
field testing".

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-7AO4cRdaB7Tr0PF0h9nO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU1nCYOe/yOyVhhEJAQpqAg/8D5hJwyY+CSaHMAsVnEeoO8t93SUNgmDk
Sz8G1zfNISrtzXw9BsjrtZ0+FjAI/vUXGXAWFxkhiedasI3zyUvyUk+3QcR9QMvy
fwBR9/ifcdzB9uh31gwzHZJgNfurBHGBxvluUnOCv3r6yhiwZwf291lmUvoj+mPU
wezaCprwTeijZ2IpxT8cBaSTOeIQmgTBtLSZfdcWnRJtUdSLlGW/Wns+/h7A5iJc
/c71Y4N/+vVq+iy0WFVDolkdU310y+dV1v2DimUCuiiaEflcmOrttWtDTaSxps+I
WOBDyLH5AocaRrrLZpjM6PvwIDWcwxRmHu2evoQ67wki+MmKunRqK1j26PvVE0ws
+9yjIO24MW9tMHdH76NvJO4gNFJo+updzZ9DzkHkOSATdujjwHnhNwHwCd5iEb/n
pvYGgZhF/jLOaTF+XDNOkNsKJNonhub/aXdv6n8Mij8YyG2H1FcOTFHp3HMWBRdz
I3By6I6nwe2Sr6kryfTqDjbGRkoVM5H7KlxbVuM3P2B3MRHvsWGWwaZ3DEO76MyN
PG+n08XfFooEgg9ERgAjOBx6FIPnMqhimjUCfIA2Vmx1x4LYCcJmb7BLSAJpV+go
Yz482C+plHrcPX/PXEE+dSSQXdHnlDIErcKmxf7Bz8sh0xMv6jtedlcg4JGh3Ixz
RFmoU8gXvZ0=
=7S7E
-----END PGP SIGNATURE-----

--=-7AO4cRdaB7Tr0PF0h9nO--
