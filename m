Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbaDXSRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:17:41 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35071 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455AbaDXSRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:17:38 -0400
Message-ID: <5359553A.1040109@linuxfoundation.org>
Date: Thu, 24 Apr 2014 14:17:30 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Organization: Linux Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild test robot status reports
References: <20140424103349.28534973@gandalf.local.home>
In-Reply-To: <20140424103349.28534973@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WPURhpKvIPkXpCIPUvD5gmvbkGt6W5qL0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WPURhpKvIPkXpCIPUvD5gmvbkGt6W5qL0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 24/04/14 10:33 AM, Steven Rostedt wrote:
> Next, and this is why I Cc'd Konstantin, maybe it would be prudent to
> have a web site show the status of your tests?  Where we can see if a
> test is in progress, finished, found new errors or not.
>=20
> Ideally, it would be hosted on kernel.org. Maybe you and Konstantin
> could organize something. Maybe just a redirect to another website. I
> feel this would be very useful to have. That way, I don't need to ask
> to be emailed, but instead just go check a website to see where the
> test is at.
>=20
> Maybe you already have this?

Hi, all:

If there isn't already a status page in place, then the easiest for me
would be a json status file that I can format and display on a webpage.
I can either pull or listen for incoming submissions. Pull is preferred,
as that would remove the need for us to set up some kind of authenticatio=
n.

Either way, it shouldn't be too hard to implement.

-K


--WPURhpKvIPkXpCIPUvD5gmvbkGt6W5qL0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQGcBAEBCAAGBQJTWVU6AAoJEI6WedmufEle+KwMAIO/0scdRxTaXA37Qq92gr+a
F50SmrTBqq1y3ZjtvkmpTAH/T6FLFUMatOVaa7g7w6VDigSRQ199BEDFUq7QSQn5
YBDUD5uhatcd4nK0bwaGOdUWbe9RPFQNP2wXor3reSZ0jIYiSb3032cwtuiFM5U6
VwjeOo2aQ8Xyfxi45SqwoWHSfrNHXRSNKiwPdAH/90g3SLbC6vspa8ewC5YGuJAL
CGEmVa4DEohL0Mq4IrDTRx0DArjnRPEYW4rSo2cZrplW/Ibr8+7KvjWM3CKBQo9/
J1lrpv/VjR/2FDJorSMurQyPyRkn7TgQga+l80DwHRAIs9+x9hUIpDKJ62RyEZiA
ohob+Ni7QCHZtHHd/2Dntr7q6zaT1GjpGEVqzzSUeg3UkHZ+glIw81m2y8QzyzJn
1P9fcCTkyqE73g/We8Gtu42KyCeg5qbrCNr8rwt6bGtEUNjXji4/AMcsH761ZeVL
cqP5flL9HJ/hxeGCKOq+u0lBmwVHQbaPY11Fom4gMg==
=9VlM
-----END PGP SIGNATURE-----

--WPURhpKvIPkXpCIPUvD5gmvbkGt6W5qL0--
