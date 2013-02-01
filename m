Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab3BARyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:54:53 -0500
Received: from mail-gh0-f179.google.com ([209.85.160.179]:34248 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab3BARyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:54:52 -0500
Date: Fri, 1 Feb 2013 15:54:45 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-02-01
Message-ID: <20130201175445.GE4733@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130201174019.GD4733@joana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <20130201174019.GD4733@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

* Gustavo Padovan <gustavo@padovan.org> [2013-02-01 15:40:19 -0200]:

> Hi John,
>=20
> Here goes another batch intended for 3.9, the majority of the patch here =
are
> from Johan who is fixing many issues in the management interface that have
> appeared lately. The rest of the patches are just small improvements, fix=
es
> and clean ups.

I had a brain shutdown moment and forgot to rebase against wireless-next.
SO the pull request is actually much smaller.

Please pull!

	Gustavo

---
The following changes since commit c331997b6c9ad7f4b8075e6e60d3caa6e36f5938:

  wil6210: fix wil_vring_init_tx status (2013-01-30 15:07:19 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next fo=
r-upstream

for you to fetch changes up to a3d09356491d637548dbe815ddb966f52ec9e53a:

  Bluetooth: Refactor mgmt_pending_foreach (2013-02-01 15:50:18 -0200)

----------------------------------------------------------------
Andre Guedes (3):
      Bluetooth: Reduce critical section in sco_conn_ready
      Bluetooth: Remove unneeded locking
      Bluetooth: Refactor mgmt_pending_foreach

Johan Hedberg (11):
      Bluetooth: Store UUIDs in the same order that they were added
      Bluetooth: Simplify UUIDs clearing code
      Bluetooth: Keep track of UUID type upon addition
      Bluetooth: Simplify UUID removal code
      Bluetooth: Simplify UUID16 list generation for EIR
      Bluetooth: Remove useless eir_len variable from EIR creation
      Bluetooth: Refactor UUID-16 list generation into its own function
      Bluetooth: Add support for 32-bit UUIDs in EIR data
      Bluetooth: Add support for 128-bit UUIDs in EIR data
      Bluetooth: Fix link security setting when powering on
      Bluetooth: Increment Management interface revision

 include/net/bluetooth/hci_core.h |   1 +
 net/bluetooth/hci_core.c         |  10 +-
 net/bluetooth/hci_event.c        |   4 -
 net/bluetooth/mgmt.c             | 219 +++++++++++++++++++++++++----------=
------
 net/bluetooth/sco.c              |  18 ++--
 5 files changed, 150 insertions(+), 102 deletions(-)

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRDAFlAAoJEPs3PUX4s20oOrwQAK5PnopbfD6PgTAewSGXmr1I
3gkO2h4uu38e8qw53NaOspLSdy+DnfRjVuWcaEncniotPYeXuBnrUQ6jizyx6CpT
4P1zlAFkS3nzMd5sSbIfgSHhYssVgG9bFP5Pll3+tOFHntIfyTqJE1pBSjOdMUCp
ZnoqbuKIq8zY337JyMStNNskI+6XLHKvJ0R7BAbZmEIXgBXuDyn1MuR8OX0jIJ8J
id19iFWDaOHBoxNIClScjUpiiSVTLqqnC5CYDdY1pDrQSvV45opTVj8fvwcE967W
fmB8hz7Us2qEDJdJOvuN8Tjy5h0NOeVf/AN/sNWHfT5Td5UWn2L8S3o3Vyt/+9Gv
YuUPLMyb5P6Pf6PLBCT+N7KULzrW8gGVf3vmgnntJcsTw/AwsoOSf7i2JHgwoeu1
yRo4lva090RB5kOPCwwMYW8oxgWJKT0YeFIOTACHvu0dxfQpcvbGfI2KSg19fgsV
1ld3E0sY8IrL//RUIjibHe9Dv60uyXbmc0RGH2YyjCO+QAl79ASune91OQ39jy+5
5zdSVgrvQNZiNLUTDl7lAXs65cdCkr98llvzHcqTqBra5eOKHk8SxSiDeLbHj7UX
otTvqtVkkKnyraj09H7w+MU/7Qnh9Qgqw0nG5KCIiaciBtz2kK3uLvAHOeiNx1be
oebkm/WksHblOd5NobFv
=pfe3
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--
