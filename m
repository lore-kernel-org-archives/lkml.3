Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbaIWO51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:57:27 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51621 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756426AbaIWO5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:57:24 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: balbi@ti.com, Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/4] ACPI / platform: provide default DMA mask
Date: Tue, 23 Sep 2014 17:17:03 +0200
Message-ID: <2422219.EN0C5cKd3e@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140923145221.GC28592@saruman>
References: <1408535728-10518-1-git-send-email-heikki.krogerus@linux.intel.com> <1487657.QLes1WRKBI@vostro.rjw.lan> <20140923145221.GC28592@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2055055.yTBpTG64FJ"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2055055.yTBpTG64FJ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, September 23, 2014 09:52:21 AM Felipe Balbi wrote:
> On Tue, Sep 23, 2014 at 04:52:01PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, September 23, 2014 03:17:12 PM Heikki Krogerus wrote:
> > > On Wed, Aug 20, 2014 at 02:55:26PM +0300, Heikki Krogerus wrote:
> > > > Most devices are configured for 32-bit DMA addresses.
> > > > Setting the mask to 32-bit here removes the need for the
> > > > drivers to do it separately.
> > >=20
> > > Rafael, is this OK?
> >=20
> > Fine by me, but it should go in via dwc3 I think.
>=20
> huh ? Seems like there's no direct dependency.

Well, it's part of a series where all of the other patches touch dwc3.
Doesn't anything in that series depend on this patch?

=2D-=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart2055055.yTBpTG64FJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJUIY72AAoJEILEb/54YlRxE+oQAKMio6jzsP/Q/CUahFQTXwq9
dM24cN3XV3OaGnQdsAjln9cMjJArBYCoFzIVpONtaVrr5byy/Z2rYTLIKvGTBjV1
7Dfs+RLSCKkCSuwveCInWHkE+VOAL3jvDs+xbRS/w9FKmu+BzZAv36cQkkyy9U+9
36oSroXctm3BHlgOq0tm9tIDvx7bQJRlByEySqXr8JyXA97CLWpkpsnmP3e01FhH
SvChwJa4F71qRu95lHfdb7R+XZsy6lpyeOEq8VLJCOWH3fQrljYNvQC1tkl1xwtS
ufn/bamkjF118zuQLud+rAmf8U+8EUbC3Q/tc60GYwB5yaSBajJQilAES5bjWOm8
PIRUZb6GgZuSwuv9Qh/vX0LZXLGKzYSmOxKRCb1XLCxTAwWeuNmAU+zZFVn255aR
BX9DMzW/oPINd9w8ar8eAf1I2jxNADhSTPXj/iwzKwKavZd04IpJrSrw9tm3J7P1
E7HmPASi/lwLDxnXw718mcoClt0KDuQN9b1Zwvwr+4zMKRAW6huZ8xpT6WASky2G
ujlbZWUgHQGgRUH0P/MqfX9rdp56OYxJRD8Y4Qp0sfCxwLKK/JQSli8puPWcIY6X
4isHHs6oxREh+aQoSgk7MSPDlcC8V17PqtqQyPjXNyPtzgBJgHapgD6gHp0ukXhU
30u4YBuTnMLb37nanP1B
=Hz0k
-----END PGP SIGNATURE-----

--nextPart2055055.yTBpTG64FJ--

