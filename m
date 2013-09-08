Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab3IHFbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 01:31:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3IHFbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 01:31:13 -0400
Date: Sat, 7 Sep 2013 22:34:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.95
Message-ID: <20130908053416.GA1737@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.95 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 -
 drivers/acpi/ec.c                             |    4 +++
 drivers/base/memory.c                         |    2 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   10 ++++++++
 drivers/target/target_core_cdb.c              |   11 +++++----
 fs/bio.c                                      |   20 ++++++++++++----
 fs/jfs/jfs_dtree.c                            |   31 +++++++++++++++++++-------
 sound/isa/opti9xx/opti92x-ad1848.c            |    8 +-----
 8 files changed, 63 insertions(+), 25 deletions(-)

Dave Kleikamp (1):
      jfs: fix readdir cookie incompatibility with NFSv4

Greg Kroah-Hartman (1):
      Linux 3.0.95

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211

Lan Tianyu (1):
      ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Nicholas Bellinger (1):
      target: Fix trailing ASCII space usage in INQUIRY vendor+model

Roland Dreier (1):
      SCSI: sg: Fix user memory corruption when SG_IO is interrupted by a signal

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sections

Takashi Iwai (1):
      ALSA: opti9xx: Fix conflicting driver object name


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLAxYAAoJEDjbvchgkmk+atIQAKPWR+jPC8Lixd6IJSbVOqAn
sw7L+SJh1Hfj26XmW+59SK53gT8DrIxGrPcp8equf8CdBoLPb+EnuHTGiK5IKNHO
i3WqC4HTISJbkTg8U51K5Sxw3DWH5xg4i5pzTykpCREGAm43BhdI3XxPpQf40uiv
SzG8Mqa6wOEDsRt2VcbXj5te8bsUKAqdRhn9w0KZ9PuG+BdA1sbJg7aC6JKEznm+
5RYtlWVF8DQ8EVw3BgbNZ4pJ0SkJ9LnidfoMeWtpSW9Jo3eEnEzVU4M++ZczLN7l
P9QIgezrL3hEWrL99rXNgs+jO+hqZEg/tYxhtWnoAxO+ndmkTObwKzB64Rp0LvEv
jPyD/w+92sZu7dj+iMGA5UufacCb5lByRbr4Z/PDB7vGbkaeAtFZB2xGKFnU3z1F
6AJ1Cv8PTCDUs3RyW4dmB+3czdSdMcCJMu52B/0FWPUYbk/U9SW2aREGFT/6hswH
uGj3erebX1DC4alI1HUBT0f+8RKlvCQyzxfwcpjrcAUYFEvA1amyq0qofToEe73H
710fbeikrKYQi6pOlFiSBjgb2avdx9fCYG6/iA/eIPDwMb3es7EfKic+sNYj0Lwv
04iA3WEVeJwO6R4AHhOTDsnDyKbqyChCeTNLhiupAYaR021h/1UOqgOC54vhIWbn
kSQJVchh/axoDDnDDVze
=ugiW
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
