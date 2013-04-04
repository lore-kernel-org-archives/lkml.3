Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab3DDHKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:10:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32917 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763746Ab3DDHKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:10:37 -0400
Date: Thu, 4 Apr 2013 10:10:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>, <rob.herring@calxeda.com>,
        <kgene.kim@samsung.com>, <kishon@ti.com>, <dianders@chromium.org>,
        <t.figa@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v3 00/11] usb: dwc3/xhci/phy: Enable runtime power
 management
Message-ID: <20130404071015.GB30287@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <20130403172751.GC10089@xanatos>
 <CAFp+6iGnDUSOjVgu9ZCAPF9rUDWD5r9ZttBtTo864Q2ACvKFrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <CAFp+6iGnDUSOjVgu9ZCAPF9rUDWD5r9ZttBtTo864Q2ACvKFrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 04, 2013 at 10:34:57AM +0530, Vivek Gautam wrote:
> Hi Sarah,
>=20
>=20
> On Wed, Apr 3, 2013 at 10:57 PM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> > Question: Do you still need this patch for 3.10?
>=20
> Felipe's 'next' is closed for 3.10, so this series won't be making it
> to 3.10 now, as a whole. :-(

right, besides we're still discussing what to do with the whole PHY
part, right ?

--=20
balbi

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXSdXAAoJEIaOsuA1yqREQ3oQALQFs7jQxY9jOwkdN8Y6mUPg
yE08Ai/PXU+nGrfgYRMQMl4g1ONZEfYkbiJ6NyklhlnkhuY6iTpiAn3sPreuQoCF
QexIgfQQUav0IkaiQZlYmvOY6jLk+ZBJ79azSOv9h/JYjdBFxM9ONkD4KziJuPup
fpImLBnjwwRyXiTayi/GXaN/YL6HQdYWO4ZpUeo4LFBBTDZh4WmA3FDKDGUGTz0N
9Mzz+p97ylT3d3gEhb8BjklvLriSSNcWL3WpgPJ0avTXvDaTLbS0ue8FBHsWXDWe
+9KGKWOUQf6hvft0VJiiKjxtGcV1D2iQYDSpBWFE+42nDlR/UB07WIDkIcQTanXP
Hh0lgJ6ZK60NVzNe6UmwKV4Y+YA1ck4zuHllIEiHGF19sREcLLImVCVlq6BfOH5e
Gv+zbe69imlLi0je5BMv86t9M+DzSZcI/xT07g8UEluV95/zcDU8RmqYkNwtlusi
Jr9Fi4edaWVSbaYxeSHWQhV2AjGbjmn2bClrnR0jI9GyipLu3omi7xWd4V5De/vg
AnRXogS105c59YSdqyJJTqFWv1M971tQDy0zETLJJ6rbkf+WuOnMI3Ax2P/QoZ7o
Tf25e1PmWhDxLGOtVtQ8JHUUoGuwoZfanFIEJkTYb2zIF0rwcxvXp3NE1yURfbBC
4WUPrYblfwMxVoPuZ3jm
=LJzP
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
