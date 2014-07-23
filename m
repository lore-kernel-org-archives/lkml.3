Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881AbaGWWDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:03:19 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:53954 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437AbaGWWDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:03:18 -0400
Date: Wed, 23 Jul 2014 19:03:11 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-07-23
Message-ID: <20140723220311.GD1628@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Some last minute fixes for -next. We have a fix for a use after free in
RFCOMM, another fix to an issue with ADV_DIRECT_IND and one for ADV_IND with
auto-connection handling.  Last, we added support for reading the codec and
MWS setting for controllers that support these features.

Please pull! Thanks!

	Gustavo

---
The following changes since commit c2aef6e8cbebd60f79555baeb9266e220f135a44:

  Bluetooth: Add support for Broadcom device of Asus Z97-DELUXE motherboard (2014-07-21 15:07:08 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master

for you to fetch changes up to 4b9e7e7516135b1d5f047ad59188b5355bacc106:

  Bluetooth: Fix issue with ADV_IND reports and auto-connection handling (2014-07-24 00:37:23 +0300)

----------------------------------------------------------------
Marcel Holtmann (4):
      Bluetooth: Read list of local codecs supported by the controller
      Bluetooth: Get MWS transport configuration of the controller
      Bluetooth: Ignore ADV_DIRECT_IND attempts from unknown devices
      Bluetooth: Fix issue with ADV_IND reports and auto-connection handling

Vignesh Raman (1):
      Bluetooth: Avoid use of session socket after the session gets freed

 include/net/bluetooth/hci.h      |  4 ++++
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         |  9 +++++++++
 net/bluetooth/hci_event.c        | 33 ++++++++++++++++++++++++++-------
 net/bluetooth/mgmt.c             |  9 ++++++---
 net/bluetooth/rfcomm/core.c      |  7 +++++--
 6 files changed, 51 insertions(+), 12 deletions(-)

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT0DEfAAoJEPs3PUX4s20ojjEQALgjJ05wDu6l0B/4OId4SgqF
Brb1f5+PlDV4to5je968rUqPGUvYP647Swho7fikYDZ+1I1Gm3pnDYSUY6CcTINr
buiEC++QAVmTbgEazHW1MboLobBeBWuXDlrpl+fZbtOIqgCRM3fYRXQL9LHuA7dB
t9W52/EGBpjzmFoFABVuVaPzm7GDSVXBPkOQ5/0ilKtr5dU/L4Q2pz0KDfm4p2jn
msaNNiXy9zGbrvXr23aSm+nYz3KPcw/ABJA5LOdUwTj8pvre/gj4JV8DkCu/xnvA
WimUUwiUUshDpB38PIVOr9EL+cfKW6DRQfdhXG00Dz2O95dTiEn4X9dE4qeb9fF/
wv8EfnIsibGQfN3bRm9866garnf1dghQzKTVr7OdDobTE6LWBzvx+siuTis2R9Rf
2pLVO9z7HtwBalOEpB3bPGVxMJNHsL8cp+cKaM2mXWNaUiR9conT1VQMCnq1FbkH
zC4BS16USMZmo0KK3nN/UPypVoDRcB5Y9oW7D5Nw3BYjVuZ9kIykEcHJK4LUezWZ
suxQR243himj1k5iNSI5VAX7EQxVQf+e2gEsmjpeWeoz7M9lSDCZ6CroNtnY9pEM
PxOY4yShaRzGkp1CLEmD9uEaLlJyzszHShW+BSphOiXsHONmb5jPJHgVyCQhy2vA
yL+zNO3dOKo405bCfyLm
=Mxyf
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--
