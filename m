Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab3CYXRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:17:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50861 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab3CYXR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:17:29 -0400
Date: Tue, 26 Mar 2013 10:17:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed to fetch the osd tree
Message-Id: <20130326101717.36b4a4c2e23b108a9592b32c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_10_17_17_+1100_pTRxlc_KQUCO.qnf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_10_17_17_+1100_pTRxlc_KQUCO.qnf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

Fetching the osd tree
(git://git.open-osd.org/linux-open-osd.git#linux-next) produces a time
out and this error:

fatal: read error: Connection reset by peer

I will continue to use the last osd tree I fetched.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Mar_2013_10_17_17_+1100_pTRxlc_KQUCO.qnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUNr9AAoJEECxmPOUX5FEDg4P/RDV5U3U47yRfP3HO9RrkeBF
1f6gALTEInAmeXb5FKC0mNK/H2kF9wQ/KHPm3uewqfpZ3OHoh6AQWZh+HuEbsNQK
lS+1/MXxSu+BcrLP42J+x4lT8FzhvjpOouWkH1OoqCq3fcINiBKGy26dSWzr/oCh
Q+NkKR3NMnVYQCoCjuktMbgPuhUoEQ+H2xmQI9EKDH5GW+9yXqn8V/eycmfw4lDl
EFtUSCslC8vg1QNROHh7uXlTGoR8JgfIINsMYXNtG0MF/bh04WMJsw+1plli1cgD
3Wf/3+JMBiYdpnNlhh9e5KIS7B7hbQIy0crkWSKK0hLBv1oMBY4ey/UOpAH+Es8Z
oIYqdS3yXpED3c4UzrKPfV0WvUELdsctPILObrC46K1EKl9P5ibU25TiFOccaWfP
TmQEuxwU8w26QIC34uHUcsKsiHYjQt2cFGdFTwMPg1DU7F2dOVF200Vzd1Bt5Irs
RIVd0O1PzQzHk1PQjkNcmrgspLJVoUnPcH9wYt4NrzFlPK5xWxdNYJQKaMrwkrfu
b1aKF48v5+NXXmuSzcVpZBf0rJdiADZDQNDCffGaKil0N++Z6YxNtoFScR9yhddH
glDvnSyvYbU6NtzabGqnoqrVBKp5UIOyVzT4w3FT5IfK+mVbUalVjjWhCQpFiKnQ
N0Um2QBLluCJJ2enYCZk
=UKJ7
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_10_17_17_+1100_pTRxlc_KQUCO.qnf--
