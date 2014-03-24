Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaCXRdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:33:41 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:61040 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaCXRdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:33:39 -0400
Date: Mon, 24 Mar 2014 14:33:32 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-03-24
Message-ID: <20140324173332.GA2214@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here follow another set of patches to 3.15. This is mostly a bug fix pull
request with the exception of one commit from Marcel which adds tracking to
the current configured LE scan type parameter.

Please pull or let me know of any issues. Thanks!

	Gustavo

---
The following changes since commit 40b552aa5a0bfa785bc7ddb5c2d7965b1e0bb08d:

  Bluetooth: Enforce strict Secure Connections Only mode security (2014-03-19 23:30:32 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream

for you to fetch changes up to 8396215d4865d66be9cdfcec8d135862e1fd98d1:

  Bluetooth: Remove unnecessary assignment in SMP (2014-03-24 08:43:50 -0700)

----------------------------------------------------------------
Amitkumar Karwar (1):
      Bluetooth: btmrvl: don't consume all vendor specific events

Johan Hedberg (10):
      Bluetooth: Fix passkey endianess in user_confirm and notify_passkey
      Bluetooth: Fix address value for early disconnection events
      Bluetooth: Fix potential NULL pointer dereference in SMP
      Bluetooth: Add missing cmd_status handler for LE_Start_Encryption
      Bluetooth: Fix SMP confirmation callback handling
      Bluetooth: Add SMP flag to track which side is the initiator
      Bluetooth: Don't try to confirm locally initiated SMP pairing
      Bluetooth: Remove LTK re-encryption procedure
      Bluetooth: Fix potential NULL pointer dereference in smp_conn_security
      Bluetooth: Remove unnecessary assignment in SMP

Marcel Holtmann (1):
      Bluetooth: Track current configured LE scan type parameter

Thomas Gleixner (1):
      Bluetooth: bluecard: Use del_timer_sync() in teardown path

 drivers/bluetooth/bluecard_cs.c  |  2 +-
 drivers/bluetooth/btmrvl_main.c  | 11 +++---
 include/net/bluetooth/hci_core.h |  3 +-
 net/bluetooth/hci_event.c        | 63 +++++++++++++++++++++++++++++++-
 net/bluetooth/mgmt.c             | 20 ++--------
 net/bluetooth/smp.c              | 87 ++++++++++++++++++--------------------------
 net/bluetooth/smp.h              |  7 +---
 7 files changed, 111 insertions(+), 82 deletions(-)


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTMGxsAAoJEPs3PUX4s20oFTEQAJ6jBRVgqWax/cdDqHwNF31y
/d1taW4nLwlbyVQoMjB1i0BxJJAWILgxs8BjiG1jBSkMfi+GmtiJom6LcaRCl3WR
NaYGY93gseO1Fmj9Q5ChOP71HUFx1/1Fo0diiKDsfl2qOD6lHnY6nLUxst/jn3cu
yUmWhnM+aE6ixUeagf9/jZO1bodMqOvL2FOoXwlAVSDpm6LQAS7OIrCj+ZRMdDO3
7OozQaQPr4jeyzWj8sabkUryM2/YUkAWeCMnL8LFYrXiIzFXilxMpN6+aJzxWeqo
BsXTSz/TDXsiANhWq4ED4wlr87AWYx+9ZNv1CvNB3TvYvQFX1VU56f8lUuh8tJDX
SFz0BjlmzbYurOtmx+GKnRZxWkdzBQc2/0w0oPeWVxzd5ftZfFA5A4nKQWXgQIuP
ValvvQ5xZOb8HkPVW9gGqBHs6dll7NVK2IA0fZVTzG9uyNSmbSntLqcfONIMXaO6
iWTDvl2HuOGuZKbnedNt6iUgTfSUEL25+NF8uaDosBAmzcQm9cTyZiZ9sPzNrLVi
ogGSNpACaxSzntoLhPs/cunLR+7+FxXwxYnjH/sUpBFYmhpcTjHnaEpplX4EPU+/
uwIXuJ2TCKSHET89ZGSB3km2W12GHd2c9BOk31+55FW+o84OOcjz5hzieDvW474d
rbJJsxS0Me3UG916lxJK
=0ufD
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
