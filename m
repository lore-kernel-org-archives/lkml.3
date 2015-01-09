Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbbAIJ4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:56:49 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55456 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbbAIJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:56:46 -0500
Date: Fri, 9 Jan 2015 10:56:43 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        iommu@lists.linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/2] Change order of linkage in kernel makefiles for
 amdkfd
Message-ID: <20150109095642.GD27845@ulmo>
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
 <1621810.aTt9O4Ghzs@avalon>
 <549FEB52.4020103@amd.com>
 <1678486.9ZXZnn5och@avalon>
 <54A12028.7020303@amd.com>
 <20150105154657.GJ12010@ulmo.nvidia.com>
 <54AE910E.5060803@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <54AE910E.5060803@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 08, 2015 at 04:15:42PM +0200, Oded Gabbay wrote:
> Hi Thierry,
> Generally I agree with the issues you describe in the current design.
> One task in our 2015 workplan is to change the whole method amdkfd is
> loaded, so it can independently load at any time, regardless of the order of
> loading between it and radeon and amd_iommu_v2. To reach that goal, I assume
> we will have to use some form of deferred probing.

Sounds good.

> However, for the moment, this is the best band-aid I could think of, and
> choosing between this band-aid or no band-aid at all, I prefer the former
> any day.

Looking at the patches, the dependency is documented in the Makefile. I
guess that's fine as a temporary band-aid.

Thierry

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr6XaAAoJEN0jrNd/PrOh9O8QAJldCX8K4vY+KWwbCDHfUUfo
llQLJs6E+9IkbGsD+btOjJYEPyBrlSxZ/C4GNBHIM7x+Uypj6BdCHT877nm3/Vkq
9AJcfWK3dK3zXvAXgOrQDDNMg4gpLOsUSWEuIC8/7eORP8LEM0zHhC/ZFBYxHm8Z
0Qlgva7qXesF73/mSSPgX1o/shEP4/5Vje9u7HG5hqedeYYyGmSPBVJnkMXmDYMa
hhM7pvtY6PhsxCdYzasAIr6LpkEdp0yRyrfS2or6TlfAoSRpPaXwjCFYVD/R2yjD
uy+kcTBeBsNvvyvh4MEttU2yXBBqF2dD6Mg7z6wl9sau2QeHtWw2QB803RQ4qhXE
IvJei79GR0MVb9rsliVTeHCjbPl0dS5yCgSTQAhqIfYyP4O0eoB9zicYCxOVz4Wg
a+YSkRfvwAQwYOQLjEa3puTeEYCfuGRD8Y/5iwSFd/Zas5B53yn4lg0hXVbyu2kq
65hxnUlu3OjNnPg9daXcTCbcidORChaasjfi30yET4B4wwuzyCIc7Lde3MwwayiH
mgWAxeXkyRrjdY1w1SpdBjS4TftuEZcAAWuB7Ge+V4Qpn8y7Yi7IFgbFD17u9Ouq
YM+sqo2aTatckYPhqIeYgEzc7C+yzVXWzGxSm7ZsMCyw2PeqN0O1gtFbfFX7u4Up
nZA4K56/xnAvDruakUpS
=3gCS
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
