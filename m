Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3HLCLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:11:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3HLCLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:11:10 -0400
Date: Sun, 11 Aug 2013 19:12:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.57
Message-ID: <20130812021233.GA15147@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.57 kernel.

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

 Makefile                                           |    2=20
 arch/x86/kernel/i387.c                             |    2=20
 drivers/acpi/battery.c                             |    2=20
 drivers/gpu/drm/i915/i915_drv.h                    |    1=20
 drivers/gpu/drm/i915/intel_display.c               |   16 +++++++
 drivers/gpu/drm/i915/intel_lvds.c                  |    3 -
 drivers/net/arcnet/arcnet.c                        |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |    3 -
 drivers/net/ethernet/realtek/8139cp.c              |   48 ++++++++++++++++=
+++--
 drivers/net/usb/smsc75xx.c                         |   12 +----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    1=20
 drivers/net/wireless/mwifiex/sdio.c                |    4 -
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   18 ++++---
 drivers/tty/serial/mxs-auart.c                     |   38 +++++++++-------
 fs/notify/fanotify/fanotify_user.c                 |    1=20
 kernel/events/core.c                               |   30 ++++++++++---
 kernel/sched/fair.c                                |    2=20
 net/ipv4/sysctl_net_ipv4.c                         |    6 ++
 net/ipv6/ip6mr.c                                   |    5 ++
 net/key/af_key.c                                   |    4 +
 net/mac80211/rx.c                                  |   10 +++-
 net/sched/sch_atm.c                                |    1=20
 net/sched/sch_cbq.c                                |    1=20
 net/sctp/outqueue.c                                |    8 ---
 net/wireless/nl80211.c                             |    7 ++-
 sound/core/compress_offload.c                      |    2=20
 26 files changed, 168 insertions(+), 61 deletions(-)

Dan Carpenter (4):
      fanotify: info leak in copy_event_to_user()
      arcnet: cleanup sizeof parameter
      af_key: more info leaks in pfkey messages
      net_sched: info leak in atm_tc_dump_class()

David S. Miller (1):
      net_sched: Fix stack info leak in cbq_dump_wrr().

Eric Dumazet (1):
      usbnet: do not pretend to support SG/TSO

Greg Kroah-Hartman (1):
      Linux 3.4.57

H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Hannes Frederic Sowa (1):
      ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup

Jacob Keller (1):
      ixgbe: Fix Tx Hang issue with lldpad on 82598EB

Jiri Olsa (1):
      perf: Fix event group context move

Johannes Berg (1):
      mac80211: fix duplicate retransmission detection

Kamal Mostafa (1):
      drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary

Neil Horman (2):
      sctp: fully initialize sctp_outq in sctp_outq_init
      8139cp: Add dma_mapping_error checking

Oleksij Rempel (1):
      ath9k_htc: do some initial hardware configuration

Salman Qazi (1):
      perf: Use css_tryget() to avoid propping up css refcount

Stanislaw Gruszka (1):
      rt2x00: fix stop queue

Tomasz Mo=C5=84 (1):
      mwifiex: Add missing endian conversion.

Uwe Kleine-K=C3=B6nig (2):
      serial/mxs-auart: fix race condition in interrupt handler
      serial/mxs-auart: increase time to wait for transmitter to become idle

Vinod Koul (1):
      ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION

Zhu Yanhai (1):
      sched: Fix the broken sched_rr_get_interval()


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCESRAAoJEDjbvchgkmk+seoQAMpfy5ucMpgtkCJVW4/H1AeB
OUv97LHfrWESNtFzqgiISto4FpBVzUnjbjjsGMvAwfcQD4RvQvwRhW02EWp58kQp
Sv+sBE+cON3wsIC4GC9H4Fn4mJyhaH9w3O1MWFSkXw6h6CiUYUVrCTrVUilT3ujE
S4PWgdebANaOxWY8bH/1HqM+AZ+wOnpkNr5o2Gq1xR7fb/I2fHRgU6MLer+LDV4t
Wc15BPNaoCMj+cB5D3ekDgQ8CD8t4iyQMOXFVVd//G7I32O4ds6BCmJTOaYPXBAK
10ywLHfTS3zze+2uMODUmUqaB74npfj5FG0nUUqILXxS0+OKFF+lpv+65JIKqaWt
RMcSuTFjZ5X55aRr9dhPvJC1LY7BZYySgssIEFyHFHqg5pwVfpMehBwTIaKXYpbo
Lf+RYJfCgKSXmIcKNe13Xoc7U34gdh1DCZPZeIYti32f9W1JyUVMg4Y9Mb0qTRwq
ick3D0NyypVDendp5ZbpaIemJbPaEXZGG0HwsBYh4/lN5KSbpieOcL5nkmjUT6qG
kxvNBYCJJMlzHYgbvpNVc/qsoKT4dS4fg4C9msjDsuK9KIWHiSNGgBFDyJjWE17g
ZfwcS3zk6Jm5dw7euLpLAgy/1M5guoHkbBF3D+h8xABLzGxWTY5og4KBKIQ3SrTz
EfZaUPymFX3VEs/2e1yU
=dzEQ
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
