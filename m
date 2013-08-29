Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3H2SA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:00:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab3H2SAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:00:25 -0400
Date: Thu, 29 Aug 2013 11:02:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.60
Message-ID: <20130829180247.GA32281@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.60 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                   |    2=20
 arch/x86/xen/setup.c                       |   22 +++++++++
 drivers/ata/libata-pmp.c                   |   12 ++---
 drivers/gpu/drm/i915/i915_reg.h            |    2=20
 drivers/gpu/drm/i915/intel_ringbuffer.c    |   12 +++++
 drivers/net/wireless/hostap/hostap_ioctl.c |    4 -
 drivers/net/wireless/zd1201.c              |    4 +
 drivers/of/fdt.c                           |    2=20
 drivers/s390/scsi/zfcp_erp.c               |   29 +++++++++---
 drivers/s390/scsi/zfcp_qdio.c              |    8 ---
 drivers/xen/events.c                       |    2=20
 fs/nilfs2/segbuf.c                         |    5 --
 include/linux/wait.h                       |   57 ++++++++++++++++++++++++
 kernel/workqueue.c                         |   67 ++++++++++++++++++++++--=
-----
 14 files changed, 187 insertions(+), 41 deletions(-)

Chris Wilson (1):
      drm/i915: Invalidate TLBs for the rings after a reset

Dan Carpenter (1):
      Hostap: copying wrong data prism2_ioctl_giwaplist()

David Vrabel (2):
      xen/events: initialize local per-cpu mask for all possible events
      x86/xen: do not identity map UNUSABLE regions in the machine E820

Greg Kroah-Hartman (1):
      Linux 3.4.60

Jussi Kivilinna (1):
      zd1201: do not use stack as URB transfer_buffer

Lai Jiangshan (1):
      workqueue: fix possible stall on try_to_grab_pending() of a delayed w=
ork item

Martin Peschke (2):
      SCSI: zfcp: fix lock imbalance by reworking request queue locking
      SCSI: zfcp: fix schedule-inside-lock in scsi_device list loops

Tejun Heo (1):
      workqueue: consider work function when searching for busy work items

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP

Vyacheslav Dubeyko (2):
      nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPN=
OTSUPP error
      nilfs2: fix issue with counting number of bio requests for BIO_EOPNOT=
SUPP error detection

Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSH4zHAAoJEDjbvchgkmk+fccP/A8WRzgZobRwqA6X9oq1rSoU
DB+dwFUW58uvqAeB42SXypzjuBgD+dp6RG839I+YrQrj3jXts7f0knt+H9K2As/X
ZPHQq4oLSazK7XIaAE7e8eduyeJ2ug3KG09R4I7CQZQZMXam/zucF4V42xRxXv4F
Se3iXFuOIgAZb9INXss3q3M7cuSa7EXq6oUFqUkAlIwC4cHUStv3oBxRC/+i/kcv
PQ+vZCqv8x7b7DIQ5uPN0I79F2JNdqJo0f9LTYNVL110VLuADmi9BdLxHArhaqpL
AX+iNFnpRFNQ42eei790nJX+tWsUBA+XDrRYbpive8cXnxFgZ/e/MLPVt7NJWsVP
IIUj+HydPSR1aHdXVrnDqJbKdgjqA1dPEIiW6dDOoCYZ/pYY/RgNs9TDR7U5eaQ/
G1LISn8txO01HyCc+Dt1ws7nBsMhDXqLWIspwQbNdwU8VAh695y3rzPkKWVS0fIj
jfV6G6CJqB87X6DlQTw/g5mnTe0XuF8cPSiTZOD7eATn7b8icGHHVPjpsg7OaRp9
PQlMxVc/dRGxMxJsiPTwDYZwhq1s7j71NPX1hRgE8Ipa/l7pD/j2azlB/m5acI2u
XrVOHRLXiwnen8o2amqrG07j3WtJE2jUNZY3WAXTcTdi7W+lWpnlUiZC2JbE/8B0
de68qCCNhnt+CWyKhTH1
=MhKc
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
