Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3LAAmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 19:42:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:65425 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab3LAAmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 19:42:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,804,1378882800"; 
   d="asc'?scan'208";a="417357455"
Message-ID: <1385858566.2248.79.camel@jtkirshe-mobl>
Subject: [RFC] Fix Free Software Foundation address in file headers
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 30 Nov 2013 16:42:46 -0800
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BDW4jfmCbkzPPigL7LAi"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BDW4jfmCbkzPPigL7LAi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This came up when John Fastabend got a patch to fix up the headers in
the drivers/scsi/ directory and so I did a quick search of the network
drivers and found several instances in the file headers where an old FSF
address remains.  The old address is:

59 Temple Place - Suite 330
Boston, MA 02111-1307

The current address is:

51 Franklin Street - Fifth Floor
Boston, MA 02110-1301

I am wondering whether it may be best to just put a link to the Free
Software Foundation web page instead of having to update the address any
time a change is made.

Either way, I feel the address either needs to get corrected or changed
to the URL, even though I am not a fan of huge patch series to make
trivial changes like this.

Thoughts?

Cheers,
Jeff Kirsher

--=-BDW4jfmCbkzPPigL7LAi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSmoYGAAoJEOVv75VaS+3Ol8AP/1bfaYV5kFBLI5RzoMVIpDRQ
H0p4U1YNdE2h36I1wGvytRpTtRNF99zcLjRGTz7xsOlUxFl6AhIY6gbwtLQySc3H
Q9QNufRVbwCt/RfieGsDCzaYfXOpwEDif0F9Uw5OJSHNx05JQI9I61IWZGjJnu+d
nNX3YpvvS4g7iq339c+k2gzMQErlnC4OToJxFRMxSBFfqxmGiav7pPir7NkQh3Jv
imsPulZKCq7eCZL37u1hqRjn/4Yg8GIlvntqO2+lrl17xVUdVqpp98B7u0BMO49q
B+8cad81W3C+nYZtTVln3FOvQjLtxVb2gXzt2xh/tQ95sCsVG+meInrqzHwGmC+Y
qBiNqFxXFbgLKWlDbZusrEO3yq6DSAust3dhiCOi6bS6O9xhwcnPKMehGKfsLJBi
G6tjJUZS3oNn0HY1cMWEi5Bo38kLd36DmdHqFPd+pe/FTzKekA0EQzsgcuNMwy8y
/fodgj6Qmd94d5narlHEcUOPlzBxvDc+9amIZDD7rLBFXb4R8bPrwP9iaL5hCgA9
Qmh4uGJIa86SlKohmr8Y3BwnrQj3S6zyys60R5dsfOH5fK3/mH2LqWqfq+MS2RE5
rfklGfJNr6SOlfofBSzBUioaW1XbsnwGgrBuE48hwoY58F0yJyNDsLNENonMNTgo
TRGlhLLYuNIvDIy9GTYQ
=L7AD
-----END PGP SIGNATURE-----

--=-BDW4jfmCbkzPPigL7LAi--

