Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3JJK7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:59:10 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:55213 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3JJK7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:59:08 -0400
Date: Thu, 10 Oct 2013 12:57:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the mvebu tree
Message-ID: <20131010105702.GD6735@ulmo.nvidia.com>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
 <1381328067-1593-6-git-send-email-treding@nvidia.com>
 <20131009143727.GD5402@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hxkXGo8AKqTJ+9QI"
Content-Disposition: inline
In-Reply-To: <20131009143727.GD5402@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hxkXGo8AKqTJ+9QI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2013 at 10:37:27AM -0400, Jason Cooper wrote:
> Thierry,
>=20
> On Wed, Oct 09, 2013 at 04:14:27PM +0200, Thierry Reding wrote:
> > Today's linux-next merge of the mvebu tree got conflicts in
>=20
> I looked in your scripts repo, and couldn't find the script you use to
> send out this email thread :(=20

Well, that's because I'm doing them manually.

> Since I can't create a patch, I'll just ask, could you include the
> commit id of the branch you pulled in the email?
>=20
> eg:
>=20
> Today's linux-next merge of the mvebu tree (477cdaf) got conflicts in
> ...
>=20
> I had uploaded a new for-next branch less than 30 minutes before you
> sent this out, so I wasn't sure which you were working with.  Not a big
> deal, just thought I'd pass along the idea for the next time you're
> tweaking your scripts.

It should be possible to extend the Next/fetch script with something
that writes the SHA1 of each tree to a file. Stephen's linux-next trees
contain such a file (Next/SHA1s). I'll see if I can find the time to
update my scripts to do the same. That won't make it magically appear in
the notification email, but I can probably remember to do that in the
future.

Thanks,
Thierry

--hxkXGo8AKqTJ+9QI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVof+AAoJEN0jrNd/PrOhw1oP/RpYaSfS+OzmAWn55AtTzbAg
T1Wnhtui0pZB6/v4YJKmwsV9ZiNKgvQ5VOLDHTk1blUVP8DJlpD7PDHNURhvxd6o
7RooOZLQxqY2lKNuPV3upMMBr5yReDNJzi7xYLXknYT74uGKCQh1rrOj2sYIL0B9
Fia9e6/mdhKO10cyIXHVReoYpjuD+jxJ6UOCagphV9TqtLbdu9O5Noehap37MwTP
fa6GWsafEjp9UoZjczfS8odVwb2mrWf4gTDqH5USIE+a+W0csTS/CinngaSW5n6k
cLrbK1Wew2FCuVlCAR9jPfVT1vi92K326fY888C6bmEDPUsuAa9eDUmNx8CL7X8w
C9Ioh1E0e1hxWa9dKGMkKdnrfA+PjB1qq671H8CcjDPdEoWuWYof4MdzIpomVWHi
50TupxvB3YZ3dL7YQWH475wWxcanDxoro1FziNzh01/k79KIKs2aGA8TqRMsf7w2
/7Nlh80LQenA8OA1fxpU++qO1bQjuP2HwnmzKcxae3RhHHiF/GFZLBiyYC98xMAe
Q8/gBWPFMZVCyvXqi54rktetS7DWwAx8Flc0+qsTbQ/NzUfGax34Se7s/f8DYzwc
ZexId/IS8NEiUymQ4AupsnyrWTW2P/RdE2QR5s4aoUrjbbjciZkG6kMIjwgjYX+F
8CytO40E351BS/jbczYW
=sXFz
-----END PGP SIGNATURE-----

--hxkXGo8AKqTJ+9QI--
