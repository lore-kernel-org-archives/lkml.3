Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaHSOx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:53:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49443 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaHSOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:53:25 -0400
Date: Tue, 19 Aug 2014 09:53:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH v3 0/3] usb: gadget: f_fs: userspace API fixes and
 improvements
Message-ID: <20140819145311.GH16085@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xs+9IvWevLaxKUtW"
Content-Disposition: inline
In-Reply-To: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xs+9IvWevLaxKUtW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 11:43:40AM +0200, Robert Baldyga wrote:
> This patchset contains changes in FunctionFS making it easier and
> safer to use. It fixes bug in endpoint files handling code, adds new
> ioctl allowing to obtain endpoint descriptor, and introduces virtual
> address mapping which allows to separate endpoint address space in
> function from physical endpoint addresses, and introduces new endpoint
> files naming convention.

I'll drop this from my queue for now. Please fix the minor comment from
Sergei.

--=20
balbi

--xs+9IvWevLaxKUtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT82TXAAoJEIaOsuA1yqREKikP/0PXM+AlkLe/O4iY7meowkqe
+NdcTCi+1gtVKr48awwAGV6C13NOIo2+nRSnO5VHgWI9+ZB266npRUdH4L/fJJxX
w7UCdfRv4sVAs8KkAWj1ApT9vEAbSb6J3gvrH1vcdYcgg7zSq11BEmTGtEDF7INe
tRk+Xi5OuYzysZCtx7Xk5Nz7Xsh4ARtPTfVFULCv+Hd2nPH1MCWPW+DL9iduz0BG
N2sYt7q1kfuDhLVzkw5h3wcm5DIhxmq3v5MvpvuGPuxKGd/5gynqCMQmH6oVmePF
MBzQ6/+rjE9jEhkyouXmxK/jlc/IGiW4YpVnYnGCXyjb8wK2Mbn3u6ZrehgKNZKP
1zPSdQxsHDE/HPfHJgwW/DYYuqR+5bBzB1xr7RVKiDf4ilHaWa2DRVLyuHaU2T2q
W62SnGFD5tl4M9LsYiNSLqAg/Sx8ccdwgCEatcxvyqipzR82M7/C1+8F/mZZXjvG
St8Hci6dmTj1ePiVH8X1JMGo+Dpzluip/WtmUDFug42jdw+sQzmHAnMCsCUMjpp5
G6t+NF5xMJ3PvKEYKF/yXkqaol5+S8GX0PULfFyGm3ANAW/TBCs2nA/6cU95D9Ss
i21mMts6rWCw/H2pqhCOOWa94k9xC6ZR65Kc7Qc/I/bjBIia0r+bEj1wL9Kxo5Gv
NhS7MEotklolYvGU7o2Q
=eLQ4
-----END PGP SIGNATURE-----

--xs+9IvWevLaxKUtW--
