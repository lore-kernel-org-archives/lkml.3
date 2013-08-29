Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3H2R7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:59:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab3H2R7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:59:47 -0400
Date: Thu, 29 Aug 2013 11:02:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.94
Message-ID: <20130829180210.GA32225@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.94 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 drivers/ata/libata-pmp.c                   |   12 +++---
 drivers/net/wireless/hostap/hostap_ioctl.c |    4 +-
 drivers/net/wireless/zd1201.c              |    4 +-
 drivers/of/fdt.c                           |    2 +
 drivers/s390/scsi/zfcp_erp.c               |   29 +++++++++++---
 drivers/s390/scsi/zfcp_qdio.c              |    8 +---
 drivers/xen/events.c                       |    2 -
 fs/nilfs2/segbuf.c                         |    5 +-
 include/linux/wait.h                       |   57 +++++++++++++++++++++++++++++
 10 files changed, 98 insertions(+), 27 deletions(-)

Dan Carpenter (1):
      Hostap: copying wrong data prism2_ioctl_giwaplist()

David Vrabel (1):
      xen/events: initialize local per-cpu mask for all possible events

Greg Kroah-Hartman (1):
      Linux 3.0.94

Jussi Kivilinna (1):
      zd1201: do not use stack as URB transfer_buffer

Martin Peschke (2):
      SCSI: zfcp: fix lock imbalance by reworking request queue locking
      SCSI: zfcp: fix schedule-inside-lock in scsi_device list loops

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP

Vyacheslav Dubeyko (2):
      nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
      nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection

Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSH4yiAAoJEDjbvchgkmk+jWEP/2numQsRqALIqP9OUpkolhoS
YjkIpG6nvh1iPwBj0wZyYhFPboW5eXSLuuG3OzkimJq+SLQinI6h+/xiyX4woOOC
YrPqbHshqaa+Ki2DXELmimsCm0DV3ehPDNMUZsfD07KlHwJlDATioGvxjTjqn+gM
l6UVHm0Y+E60qkJAODjQOY3ooFNaFT8EjQ1rhdlgyNDXhSB4j7i2LT4keyHu83Tu
wps4kQDnd3HHJBuTYq9Eah31iGtKYt0AWu1qJA+izDkODa4SsHagMskXpn4Wlsic
N3mu/BlDHzhz+cZY5GPXE8ZGD2y0CjZ6l3Q/1x5HCMo2tnGQrIvitbKADQs9HFdt
ZkKWgrPeZV3rgm0QJfD/2EMTiHl8ywtIFSVBcbJ25lnYF/4mS7Wgl5CF75i0hSCq
JwI1Jd19gy1jcuCuNzHHq1pyYOhc0aN7nXil9W+TuKZGiFLPkfj5AWVAtSghgaWf
dsAxblPGlDnIeosSa5lejiZNdBaWWtWcKQNXam9s+/QZ9FntEYnoQ5zvaCOWt6lQ
zNcAnWmFGsPoW89d2DETxwNeE+Md1i+T8sz2Ihcw8vdLwHfa081fEl8cy7bFaDMF
p1PEKv8wt3Ze/zU6ZRlJaraIzE1eHsLr4OZypyMzbw34YqQdnOvi/caMTzAREzh2
gbH0t+1Bwi4uFW8k2K78
=8bjj
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
