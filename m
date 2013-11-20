Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3KTUke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:40:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3KTUkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:40:32 -0500
Date: Wed, 20 Nov 2013 12:40:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.20
Message-ID: <20131120204052.GA2027@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.20 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                  |    2=20
 drivers/media/platform/sh_vou.c           |    2=20
 drivers/misc/atmel_pwm.c                  |    6 -
 drivers/net/ethernet/chelsio/cxgb3/sge.c  |    3=20
 drivers/net/ethernet/mellanox/mlx4/cmd.c  |    2=20
 drivers/net/virtio_net.c                  |   13 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c   |   42 +++++++-
 drivers/net/wireless/iwlwifi/iwl-config.h |    6 -
 drivers/net/wireless/iwlwifi/pcie/drv.c   |   79 ++++++++++++++-
 drivers/net/xen-netback/common.h          |    1=20
 drivers/net/xen-netback/interface.c       |    3=20
 drivers/net/xen-netback/netback.c         |   10 -
 drivers/net/xen-netback/xenbus.c          |  153 +++++++++++++++++++++++--=
-----
 drivers/usb/core/hcd.c                    |    1=20
 drivers/usb/core/hub.c                    |   18 ++-
 drivers/usb/core/usb.h                    |    1=20
 drivers/usb/serial/option.c               |   17 +++
 drivers/video/backlight/atmel-pwm-bl.c    |    9 -
 drivers/video/hyperv_fb.c                 |   40 +++++++
 include/net/ip6_fib.h                     |    1=20
 include/net/ip_tunnels.h                  |    2=20
 include/uapi/linux/perf_event.h           |   12 +-
 kernel/events/ring_buffer.c               |   31 +++++-
 kernel/trace/trace.c                      |    5=20
 net/batman-adv/main.c                     |    5=20
 net/batman-adv/network-coding.c           |   28 +++--
 net/batman-adv/network-coding.h           |   14 +-
 net/core/flow_dissector.c                 |    2=20
 net/ipv4/ip_gre.c                         |    2=20
 net/ipv4/ip_tunnel.c                      |    4=20
 net/ipv4/ipip.c                           |    2=20
 net/ipv6/route.c                          |    9 +
 sound/pci/hda/patch_hdmi.c                |    5=20
 33 files changed, 427 insertions(+), 103 deletions(-)

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix reported channel map on common default layouts

Ben Hutchings (1):
      cxgb3: Fix length calculation in write_ofld_wr() on 32-bit architectu=
res

Dan Carpenter (1):
      media: sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()

David Vrabel (1):
      xen-netback: transition to CLOSED when removing a VIF

Gerd Hoffmann (1):
      hyperv-fb: add pci stub

Greg Kroah-Hartman (1):
      Linux 3.10.20

Hannes Frederic Sowa (2):
      ipv6: ip6_dst_check needs to check for expired dst_entries
      ipv6: reset dst.expires value when clearing expire flag

Jack Morgenstein (1):
      net/mlx4_core: Fix call to __mlx4_unregister_mac

Jason Wang (2):
      virtio-net: correctly handle cpu hotplug notifier during resuming
      net: flow_dissector: fail on evil iph->ihl

Johan Hovold (2):
      misc: atmel_pwm: add deferred-probing support
      backlight: atmel-pwm-bl: fix deferred probe from __init

Krzysztof Mazur (2):
      usb: fix cleanup after failure in hub_configure()
      usb: fail on usb_hub_create_port_device() errors

Matthias Schiffer (1):
      batman-adv: set up network coding packet handlers during module init

Matti Gottlieb (1):
      iwlwifi: pcie: add new SKUs for 7000 & 3160 NIC series

Oren Givon (1):
      iwlwifi: add new 7260 and 3160 series device IDs

Paul Durrant (1):
      xen-netback: Handle backend state transitions in a more robust way

Peter Zijlstra (1):
      perf: Fix perf ring buffer memory ordering

Pravin B Shelar (1):
      ip_gre: Fix WCCPv2 header parsing.

Rui li (1):
      USB: add new zte 3g-dongle's pid to option.c

Steven Rostedt (1):
      tracing: Fix potential out-of-bounds in trace_get_user()

Wei Liu (1):
      xen-netback: use jiffies_64 value to calculate credit timeout

Xenia Ragiadakou (1):
      usbcore: set lpm_capable field for LPM capable root hubs


--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjR5UAAoJEDjbvchgkmk+pVsP/1L/A2UgxRs9i4ukjTBjSgGw
DdWgm7soGCT7PyWhbHPlt6uierOPMcZ5BZ44xYVNU1fHmHSLZ6NqAyEKExgH/Nt7
6UNeYv2T1xD3IT7ISZmkGWf0kmp/DvKsn5Fbusr2iW5yurHNWWztz1bKgMnAdCL2
DXUQpL98NCKLsmq4gyDkYubCyH0XFC9ktLDJTnskW5m8I3x9ZmtgQXNpQmpshAta
/2AxCB8z45M3/8RqXJSYEpFqmtZnzWNMtEJnlFwLezeUWQgN+Ak9ElFVm1Iuw/Tx
kC7mZp56bmsZ67SEmV6Q9VN6u/Cj7PuGsjf9KkinJ982qjbUu8T0OmJBb9xAPH4h
JTayHUetvGKp01CTcHaRci1ml2Ba8Ci6jsZUjMhpWtnZqx29ceypoBx/uXo3RNgY
Ir8+2nQ2AXWrbfwG7fMmhNCmUmJvnzZwDEbRB3tzMuHsyhTd/Sfo7FK8hTRlTIDe
OpOgzjamDdGz1wg3On9xt3WEBC9SKDUwqXpjwWC2V+xPj6ZJ6fofpeQDV94Q5omH
HYj0doXSYSl/47pIkKL63gQjj6M5ZaG9f9vD3atxcXtB1lSr0cxXT8YGk3hQdrxN
1SAhZP1GPpmeB3W7lVtKxUiKMCajiSt9jvUX3MphYiQMJk5oSu3gXagMVTAEnKaX
gD/f8nhZciQnD3WD08xA
=bN1t
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
