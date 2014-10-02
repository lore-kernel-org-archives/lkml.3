Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaJBKvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:51:11 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59006 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaJBKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:51:08 -0400
Date: Thu, 2 Oct 2014 12:51:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Move AHB Kconfig to drivers/amba
Message-ID: <20141002105103.GA13906@ulmo>
References: <1406643934-16301-1-git-send-email-thierry.reding@gmail.com>
 <53D7C9EE.60503@wwwdotorg.org>
 <53FB7288.9050002@wwwdotorg.org>
 <5408BF77.1020007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <5408BF77.1020007@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2014 at 01:37:27PM -0600, Stephen Warren wrote:
> On 08/25/2014 11:29 AM, Stephen Warren wrote:
> >On 07/29/2014 10:21 AM, Stephen Warren wrote:
> >>On 07/29/2014 08:25 AM, Thierry Reding wrote:
> >>>From: Thierry Reding <treding@nvidia.com>
> >>>
> >>>This will allow the Kconfig option to be shared among 32-bit and 64-bit
> >>>ARM.
> >>
> >>This seems fine to me. I'd expect to apply it for 3.18, provided I get
> >>an ack from Russell as drivers/amba maintainer (hence CCing him without
> >>trimming the quote).
> >
> >Russell,
> >
> >Are you OK with this patch? If so, if you could ack it so I can apply
> >it, that would be great.
>=20
> Russell?

Russell,

Can I have your Acked-by on this or would you prefer it to be submitted
to the patch tracker? Would the patch tracker be the correct place also
for non-ARM core patches?

Thierry

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJULS4XAAoJEN0jrNd/PrOhu7IP/2OXDcU/5YbDk1d+La+3k975
mDFA+JgM+fkXks/WbsE2rPcMaubQnnouMqJDg54sE8GYRZxeqDu6j4nj/wSzLDAv
Z4ztW4YcrIe0ZLm1AUtXCs1tYIOMUdnkZOTdi3CA7o+xl94n2PMo3u+tYpRcyT8R
QsSOXpVBBPRh+e/W09skFX9kG5NpHWK2lyHyRDo6L5Ey9njILeUce4/k1jEU4bXg
0nwp/w+2ysm8a3N0hF4oUJg8fD/fQ/sibUbVN3GtuURHIlR+R0rIZBMsxpWWwVeI
Vcja8nY3TKRSmK3wMYThAUpFKVIC0KvUJIl/ZQJYqrwomcby0AFFhbBw4YC7xPmk
QpQ/vA/p8fxrRCKipF5KIHaFG3bV76bN/yxQOTyiWEJDKAvnqroNP7znEQfLKjpw
Wmy47aOqeTXyO9zR3+1AU8km3hCXmiyf0A2Ld0MIyUJuL6sNzDrPXEdxBnt2jkNF
+zQ2MKB+zX7v4RDR1BRXs4WDYzmp6wDQXwgDq6CazXHpxoBWEjCJUnys4ho2eEGJ
ME6Tr2jUHrGPtF5AA3uKFcpES21Jj3qIFYFcMn3R0IKeqBFmjgKELltV3J3zjfhz
QlRFsq2KP/mXdRUShY+Y0dLf3kJUl+CjJB+R+Too8xnx5a1wwq4Vv5vrb/ZrNyeQ
miSPmvZHUfNb5/q9xXY/
=SkoP
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
