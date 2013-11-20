Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3KTUlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:41:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab3KTUlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:41:45 -0500
Date: Wed, 20 Nov 2013 12:42:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.1
Message-ID: <20131120204212.GA2207@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.1 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                 |    2 -
 drivers/misc/atmel_pwm.c                 |    6 +++-
 drivers/net/ethernet/chelsio/cxgb3/sge.c |    3 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    2 -
 drivers/net/virtio_net.c                 |   13 ++++------
 drivers/net/xen-netback/common.h         |    1=20
 drivers/net/xen-netback/interface.c      |    3 --
 drivers/net/xen-netback/netback.c        |   10 +++----
 drivers/usb/core/hcd.c                   |    1=20
 drivers/usb/core/hub.c                   |    7 ++++-
 drivers/usb/core/usb.h                   |    1=20
 drivers/usb/serial/option.c              |   17 +++++++++++++
 drivers/video/backlight/atmel-pwm-bl.c   |    9 +++---
 drivers/video/hyperv_fb.c                |   40 ++++++++++++++++++++++++++=
++++-
 include/net/ip6_fib.h                    |    1=20
 kernel/trace/trace.c                     |    5 +++
 net/core/flow_dissector.c                |    2 -
 net/ipv4/tcp_input.c                     |   34 +++++++++++++++++++-------
 net/ipv4/tcp_offload.c                   |   13 +++-------
 net/ipv6/route.c                         |    9 ++++--
 net/sctp/sm_sideeffect.c                 |    1=20
 sound/pci/hda/patch_hdmi.c               |    5 ++-
 22 files changed, 135 insertions(+), 50 deletions(-)

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix reported channel map on common default layouts

Ben Hutchings (1):
      cxgb3: Fix length calculation in write_ofld_wr() on 32-bit architectu=
res

Daniel Borkmann (1):
      net: sctp: do not trigger BUG_ON in sctp_cmd_delete_tcb

Eric Dumazet (1):
      tcp: gso: fix truesize tracking

Gerd Hoffmann (1):
      hyperv-fb: add pci stub

Greg Kroah-Hartman (1):
      Linux 3.12.1

Hannes Frederic Sowa (2):
      ipv6: ip6_dst_check needs to check for expired dst_entries
      ipv6: reset dst.expires value when clearing expire flag

Jack Morgenstein (1):
      net/mlx4_core: Fix call to __mlx4_unregister_mac

Jason Wang (2):
      net: flow_dissector: fail on evil iph->ihl
      virtio-net: correctly handle cpu hotplug notifier during resuming

Johan Hovold (2):
      misc: atmel_pwm: add deferred-probing support
      backlight: atmel-pwm-bl: fix deferred probe from __init

Rui li (1):
      USB: add new zte 3g-dongle's pid to option.c

Steven Rostedt (1):
      tracing: Fix potential out-of-bounds in trace_get_user()

Wei Liu (1):
      xen-netback: use jiffies_64 value to calculate credit timeout

Xenia Ragiadakou (1):
      usbcore: set lpm_capable field for LPM capable root hubs

Yuchung Cheng (3):
      tcp: fix SYNACK RTT estimation in Fast Open
      tcp: only take RTT from timestamps if new data is acked
      tcp: do not rearm RTO when future data are sacked


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjR6kAAoJEDjbvchgkmk+eMcQAK+WmvSKpYQq8HwlAtUjBN3m
Jk9ZuBNYzSo1yQ+dFQbF2RHKQXQJUunVgON+J06B2zQLeRnIOpdxK74Q9W1KG5cs
nJZlXe6D2cgDIz37SEzvtTzOTdoTvR+2x08TcehmRPmikyqB27rXll5jTWBzAP2a
D91xr5vdhp+2wsUz7OLeT+eYHor+h6SqMhkSm3i5N2xTmL3aED4D/xhm2mGGKoXb
7mBU2rS0vw0WdswAxYCRNcrNflZd3gjXvGsYGpVNXrt0AfK1fQZpCIo6/8sXlew+
vrzEEAgN46STPMTfkMiT76sQPUSP/ap9gwus51gVpxxY20QICrCFD3uxsDi+9Bvn
8XYa+J13KdFDe69V91T/LsWtfAUvTCu/EbTwrTdBB7+FFbg7QMEveIvFS2Tdo+Oo
k0NAV8bfF/JZCSH9qQkGiX6Ps8SWNzZqc7XeB64u7Vs8h2TOktkzl6WO9sFt/627
3kfdkff8ZD8qz93QOIDIJOjOk5fojxhHbvy4w1S7GM0GkqlLoyAZKKEoenpB4ePC
gBXsk3Lyl7LQuX5vs4myiFiuLix6WoU757EUmNsm5fkQMnwteLXFidfTocv/YAM2
Elq5KuHmCTlKfMIU7iBpCnCW4Ut8ewOF3T3qUZxGKFjZZM9LlSz6I1pczxMl7Yni
skdhk5cx/QM141YhvyQS
=dO7a
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
