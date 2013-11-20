Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3KTUlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:41:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3KTUlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:41:04 -0500
Date: Wed, 20 Nov 2013 12:41:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.9
Message-ID: <20131120204130.GA2115@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.11.9 kernel.

All users of the 3.11 kernel series must upgrade.

The updated 3.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.11.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                 |    2=20
 drivers/gpu/drm/i915/intel_dp.c          |   20 ++++
 drivers/media/platform/sh_vou.c          |    2=20
 drivers/misc/atmel_pwm.c                 |    6 -
 drivers/net/ethernet/chelsio/cxgb3/sge.c |    3=20
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    2=20
 drivers/net/virtio_net.c                 |   13 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c  |   35 ++++++-
 drivers/net/xen-netback/common.h         |    1=20
 drivers/net/xen-netback/interface.c      |    3=20
 drivers/net/xen-netback/netback.c        |   10 +-
 drivers/net/xen-netback/xenbus.c         |  152 ++++++++++++++++++++++++--=
-----
 drivers/thermal/x86_pkg_temp_thermal.c   |   14 +-
 drivers/usb/core/hcd.c                   |    1=20
 drivers/usb/core/hub.c                   |   18 +++
 drivers/usb/core/usb.h                   |    1=20
 drivers/usb/serial/option.c              |   17 +++
 drivers/video/backlight/atmel-pwm-bl.c   |    9 +
 drivers/video/hyperv_fb.c                |   40 +++++++-
 include/net/ip6_fib.h                    |    1=20
 include/uapi/linux/perf_event.h          |   12 +-
 kernel/events/ring_buffer.c              |   31 +++++-
 kernel/trace/trace.c                     |    5 -
 net/core/flow_dissector.c                |    2=20
 net/ipv4/tcp_offload.c                   |   13 +-
 net/ipv6/route.c                         |    9 +
 net/sctp/sm_sideeffect.c                 |    1=20
 sound/pci/hda/patch_hdmi.c               |    5 -
 28 files changed, 336 insertions(+), 92 deletions(-)

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix reported channel map on common default layouts

Ben Hutchings (1):
      cxgb3: Fix length calculation in write_ofld_wr() on 32-bit architectu=
res

Dan Carpenter (1):
      media: sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()

Daniel Borkmann (1):
      net: sctp: do not trigger BUG_ON in sctp_cmd_delete_tcb

David Vrabel (1):
      xen-netback: transition to CLOSED when removing a VIF

Eric Dumazet (1):
      tcp: gso: fix truesize tracking

Gerd Hoffmann (1):
      hyperv-fb: add pci stub

Greg Kroah-Hartman (1):
      Linux 3.11.9

Hannes Frederic Sowa (2):
      ipv6: ip6_dst_check needs to check for expired dst_entries
      ipv6: reset dst.expires value when clearing expire flag

Jack Morgenstein (1):
      net/mlx4_core: Fix call to __mlx4_unregister_mac

Jani Nikula (1):
      drm/i915/dp: workaround BIOS eDP bpp clamping issue

Jason Wang (2):
      net: flow_dissector: fail on evil iph->ihl
      virtio-net: correctly handle cpu hotplug notifier during resuming

Johan Hovold (2):
      misc: atmel_pwm: add deferred-probing support
      backlight: atmel-pwm-bl: fix deferred probe from __init

Krzysztof Mazur (2):
      usb: fix cleanup after failure in hub_configure()
      usb: fail on usb_hub_create_port_device() errors

Matti Gottlieb (1):
      iwlwifi: pcie: add new SKUs for 7000 & 3160 NIC series

Paul Durrant (1):
      xen-netback: Handle backend state transitions in a more robust way

Peter Zijlstra (1):
      perf: Fix perf ring buffer memory ordering

Rui li (1):
      USB: add new zte 3g-dongle's pid to option.c

Srinivas Pandruvada (1):
      Thermal: x86_pkg_temp: change spin lock

Steven Rostedt (1):
      tracing: Fix potential out-of-bounds in trace_get_user()

Wei Liu (1):
      xen-netback: use jiffies_64 value to calculate credit timeout

Xenia Ragiadakou (1):
      usbcore: set lpm_capable field for LPM capable root hubs


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjR56AAoJEDjbvchgkmk+/MsQALd1LC3VXiOTef4UrH9Vdtut
FCi3PgA2W7TKRqb9ijD6pxubUqWcud6+jwC2WqlTIerHyPrn8sBS3n8f62xByi3V
9cgxBYiKTyj55Lz6zukf1SY/yftXuIVJHWo/gXUxyGsCTDPKDbPnGwoCLEQgvEdp
UibtZwITA+oA92bK0uWdjy7q8dcPJ+8GyjgB4raN6NgOorPq6bgH8ZrLtfQtUsr+
7zR/aQS7esfftdH4xKM1HSWq3UktTDai/iS8bELb7M7DqyuJ6ICG3lu3+KjUzYwf
gDOtGP4xLZf/liGGvzhFEmS1DBuZPMWDuIC6IxZ+fQRgPk7jka4N4EVerolfS4Vn
z/o7jwXVIWLjSgigI4HYZ0X6tN0kJOWZT+/dSPlUhsQdZUZH1BJpb1DkDQIbaQqU
uKxI4wZ7WfOd16n1SvAGmVz6bO7/K0w1mYtSwqZZDTeZfaDmGviTtwQYnURU6ffM
Js/HNtITRYjXr1VgNYUjXO4nYvuG+IbPC32XevcntETIjZP/qhTabNkKoQhvZDV2
67MKRXyNmJV0YNdDXHrdyfBgE85SHeh5NqifmHHPP/8gMmm33dzpW47MZ+/C+pOO
R8jgy5UlD/2ZrDN6HWZIBCOY/S2/YYYkXcHsCfvpQdWrI82uNfOOD7bVph5VhLua
i27X5cR6jpmbmA5TfUrm
=RBG2
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
