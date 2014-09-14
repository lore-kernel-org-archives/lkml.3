Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaINETc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 00:19:32 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54411 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaINETa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 00:19:30 -0400
Date: Sun, 14 Sep 2014 07:19:12 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-next 2014-09-14
Message-ID: <20140914041912.GA1623@t440s.P-661HNU-F1>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Here are some more patches intended for 3.18. Most of them are cleanups
or fixes for SMP. The only exception is a fix for BR/EDR L2CAP fixed
channels which should now work better together with the L2CAP
information request procedure.

Let me know if there are any issues pulling. Thanks.

Johan

---
The following changes since commit 39e90c77637b3892a39f2908aea57539e961c50e:

  Bluetooth: 6lowpan: Route packets that are not meant to peer via correct device (2014-09-09 15:51:47 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master

for you to fetch changes up to 9a783a139c32a905825ee0aa9597f485ea461f76:

  Bluetooth: Fix re-setting RPA as expired when deferring update (2014-09-12 18:34:25 +0200)

----------------------------------------------------------------
Johan Hedberg (10):
      Bluetooth: Fix allowing SMP Signing info PDU
      Bluetooth: Remove unnecessary early initialization of variable
      Bluetooth: Fix ignoring unknown SMP authentication requirement bits
      Bluetooth: Centralize disallowing SMP commands to a single place
      Bluetooth: Fix SMP security level when we have no IO capabilities
      Bluetooth: Add smp_ltk_sec_level() helper function
      Bluetooth: Fix L2CAP information request handling for fixed channels
      Bluetooth: Avoid hard-coded IO capability values in SMP
      Bluetooth: Expire RPA if encryption fails
      Bluetooth: Fix re-setting RPA as expired when deferring update

 net/bluetooth/hci_core.c   |  1 +
 net/bluetooth/hci_event.c  | 11 +++++---
 net/bluetooth/l2cap_core.c | 53 ++++++++++++++++++++++++---------------
 net/bluetooth/smp.c        | 57 +++++++++++++++++++-----------------------
 net/bluetooth/smp.h        |  8 ++++++
 5 files changed, 75 insertions(+), 55 deletions(-)


--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUFRdAAAoJECQj9vv5qNQSAEYP/2C9l5K6EKCYOgyctzG/ptHs
86ANYaKuOK7ABQHWOgKIFPT+8enKCOhZl1qFNGippyP94Eti+GjXavr1+d41Zb+V
cWNZIVB1EG2P7jkUOYOwKAi9R1FkGKlRIG8MRwh3ikTNsfntn5tz6RyMJTCs/g8N
4PmF/dyQqv5wFlAXnH+VYT3ulAgAFHoM6g3T5o6xBIkwrPD+HKK1LaHajT4lJ3vs
LvV0R0x0N72ctkrCs351DZj7lsIt9KNfOmbL/JvuyQMigsDp2Sk0TimSRsEG1LA6
Y5150tgMh7N7QaTJX4eixNvOkGwr6t6MJmg2db1+a9qlQAUCYHQ2t/2E/BV8F3H6
z4f1HJ1eQHYZR3VL5GK+csulox8279nU3rxq0TDsA5ZXDj7okOIwvaGSG8N6RMJs
XePIm481VuEF1v8HmtXW/OadV5+zuKSyulluCW32q3hNmTSkb/eY5Yc5D8s1aeIm
7av+2JTpqXFYAGwIQJXdDuabHFhtlaywf8ZwSyU5efrIiHZwyg5glNoOHkNvTk72
4CoZQMddj4FADic0P//k7fDxmoLr6/Z3ZMVzQraK3in7Hh+e1UQNHBMhlXMgqQdm
0eW2LEGebr85W8KrcuNoz77qjUzsYXCfuG+HBdNeruYlWeGDbvvdrd6l+nP2tT+4
jXYIpavxs721ek/bFGnv
=DQom
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
