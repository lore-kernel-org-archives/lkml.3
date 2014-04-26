Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaDZQ7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:59:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46182 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaDZQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:59:46 -0400
Date: Sat, 26 Apr 2014 17:59:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140426165931.GV12304@sirena.org.uk>
References: <20140425203053.GA20707@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sqs1MTd/Xs/Gz+oG"
Content-Disposition: inline
In-Reply-To: <20140425203053.GA20707@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: arizona-micsupp: Fix build errors with
 CONFIG_OF not defined
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sqs1MTd/Xs/Gz+oG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 25, 2014 at 09:30:53PM +0100, Charles Keepax wrote:
> On Fri, Apr 25, 2014 at 05:11:38PM +0100, Mark Brown wrote:
> > On Fri, Apr 25, 2014 at 04:55:40PM +0100, Charles Keepax wrote:

> > > Some of the OF handling functions do not have empty alternatives defined
> > > if CONFIG_OF is not defined. This patch ifdefs out the offending code.

> > Which functions and why is it not better to provide the stubs?

> Specifically of_get_child_by_name, of_parse_handle and
> of_node_put, I guess stub would probably be better. I will do
> a patch for that instead.

There's already a stub for of_get_child_by_name() in current code.
of_parse_handle() might not be ideal, I'd need to check the usage, but
I'd definitely expect to see a stub for of_node_put(), it's quite common
to need it even for fairly basic parsing.

--sqs1MTd/Xs/Gz+oG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTW+XwAAoJELSic+t+oim9PGEP/RpT3TkD0rG9cW5QmSaopHTL
b3hKqjKcy8FLl0KLs+uhKldYZKvIKIJYwEt1R229MLmG0LxWXdx7+iNIaVB6bDkz
VpgxVK0hlPhNBFMMPPbAWXERFxU1pNxWyxMkrcqdEnDjcqoBEUevwjiPWYvJezQo
pjqm+qEHPAoAlKe3vyMj4ZBkmF07GjAtfhBpRkRmfe1GGKxA7Y38V3ueyvrQebEu
qzBugRy5jtdRndJ+eVhXBbB/ewH+RiHqvMqu4p1+2WPSJsrsD0o2eaQWkM4x4miK
xo6OQg+pubXE5W2QTyuZKZl5w0MYzPTZ1vR1WvZN4kqIdc4owKsEx68J/4AQGnPM
dLuA6gDfLHemZkG7F9XlbCt9/d99+yceo2QvOLLzAzbZF36LP4vHjbEac1runOW0
BJMF+jVc8DOyuVo2xT+izShnItjJ95UMGzY9oBUFEK+8GwicbVftmD7+7QtAwG0e
dUq1tbq5aegmrLiPJaldlxv25VUbOGk/s6+Aqt4ICBdoiYD1L82ZJu5QCk+a6Rr+
IpKzuvALCydJqC8YG4fMFUUhPRRDhXOeWw9mQ9kNAbck3kB0SQWiATp2T+GRb2th
dixZu7PJKEhzuwlGp/9BMIVmzcIOdA67sMRxl+3hLNtigzM2d5uin54Ye4M4QYOC
+D0Itu1Pk0nEBawIjU61
=EHbl
-----END PGP SIGNATURE-----

--sqs1MTd/Xs/Gz+oG--
