Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbbADV4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 16:56:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59245 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbbADV4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 16:56:00 -0500
Message-ID: <1420408540.5686.140.camel@decadent.org.uk>
Subject: Re: [PATCH net-next v1 0/7] net: extend ethtool link mode bitmaps
 to 48 bits
From: Ben Hutchings <ben@decadent.org.uk>
To: David Decotigny <ddecotig@gmail.com>
Cc: Amir Vadai <amirv@mellanox.com>, Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Masatake YAMATO <yamato@redhat.com>,
        Xi Wang <xii@google.com>, Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        Tom Gundersen <teg@jklm.no>, Jiri Pirko <jiri@resnulli.us>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Date: Sun, 04 Jan 2015 21:55:40 +0000
In-Reply-To: <1420405017-23278-1-git-send-email-ddecotig@gmail.com>
References: <1420405017-23278-1-git-send-email-ddecotig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EaGTxCSLF3yufiF+QolH"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EaGTxCSLF3yufiF+QolH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2015-01-04 at 12:56 -0800, David Decotigny wrote:
[...]
> I can send updates to other drivers, even though it's rather pointless
> to update 1G drivers at this point for example. Please let me know,
> but I'd prefer to do this in follow-up patches outside this first
> patch series.
[...]

They should be changed to ensure they reject setting any of the high
advertising flags, but it's not urgent.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-EaGTxCSLF3yufiF+QolH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVKm24ue/yOyVhhEJAQrwKhAAk00wT5jw0b2eHJxy42xW75K6WbAmy4wk
bc9QZfqzAoxmOjZ37/x99bzrbEFwHCvMeNifNzbGaX+pSgZhHfdlu3en2LULp8+r
ovZV6SXcYDBn1w+vsSZ1EEFNjeME3JFRMp7WM9y+UJrw1OsIsl0DylyjCSYvezgV
Lkv/cF2mVPKfUgAjwZzQP/m5zFcb2Ng+elozwvdoXCITCzw8OTkI9mHvqX40Cai9
690+CBHJCdzAygS/ibVTV7PDwjuVRhwu5z0fxU064+252YbqSl1AXsUYLzvQjX4/
a5a5QdlUU96eK564Lc8rPmesS+qY5cWbpBe5+yWBnNWHdC/uPM0CKjTwtfN+GqAX
ooXtSnWpFO4psOJJIEHFCboxsQGx0ydH9pKq/G1NqDw8I2SAp6rCtW6hdqOW2OpA
i7TNt3AcRUybfujOkfDQIetDXpri9PXConFf4XHhex0Fg2zFAA5zi6I1HzhBi6Op
9G8dxfrYO+Q9xotouOCz6jH8N26VF5m+deyx+/nC3lHD4D1TxboTIjaPM2tSBHiG
Op+ViVyG/ZwI1jaVObC1lB7pMWiIg6icxXrVvtTir0KcAX9xAGxqTu50FD8eNJp2
4r9Dg83dLWyzNcsljrO4As4QnMews9UdoD0iTAZQam62G1PeyjAFoIOSOJC2Iz+l
+1h5swgNXec=
=PMb/
-----END PGP SIGNATURE-----

--=-EaGTxCSLF3yufiF+QolH--
