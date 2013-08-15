Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3HOKyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:54:13 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63923 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3HOKyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:54:11 -0400
Date: Thu, 15 Aug 2013 12:54:05 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH 2/2] ARM: dts: USB for Tegra114 Dalmore
Message-ID: <20130815105404.GA14301@ulmo>
References: <1375292543-7896-1-git-send-email-ttynkkynen@nvidia.com>
 <1375292543-7896-3-git-send-email-ttynkkynen@nvidia.com>
 <51F9550F.3080503@cogentembedded.com>
 <51F9660C.6090604@iki.fi>
 <51F96B48.10209@cogentembedded.com>
 <51F98A78.9060309@wwwdotorg.org>
 <51F98D92.3010607@cogentembedded.com>
 <51F99DE4.7010503@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <51F99DE4.7010503@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2013 at 05:29:40PM -0600, Stephen Warren wrote:
> On 07/31/2013 04:20 PM, Sergei Shtylyov wrote:
> > On 08/01/2013 02:06 AM, Stephen Warren wrote:
> ...
> >>>     That's really horrible design.
> >>
> >> Yup. Both USB PHY and EHCI controller registers really are interleaved
> >> in one range.
> >=20
> >    But the standard EHCI register space has no holes IIRC, so they can't
> > be really that much interleaved as you're describing (unless you have
> > some non-standard registers of course)...
>=20
> Yes, there are certainly non-standard registers.
>=20
> ...
> >>>     Don't they cause numerous resource conflicts while device nodes
> >>> being
> >>> instantiated as the platform devices?
> >=20
> >> No; the driver knows that the HW is screwy and there's lots of
> >> register-range sharing going on, so it simply maps the registers, rath=
er
> >> than reserving the physical address range and mapping it.
> >=20
> >    Yes, it's clear that the driver should take special measures, I was
> > asking about the platform device creation phase. What do you see in
> > /proc/iomem?
>=20
> The drivers don't request the memory region since doing so would cause
> conflicts. Hence, the regions don't show up in /proc/iomem.
>=20
> This actually isn't that uncommon for DT-based drivers anyway; many use
> e.g. of_iomap() which IIRC just looks up the resource and maps it
> without registering the usage.

Not being uncommon isn't a good argument. The problem with doing this is
that it sets a bad example and makes it easier for others to do the same
thing. I can see that for some drivers providing a proper abstraction or
encapsulation might be more complicated than necessary. But I've also
seen this kind of shortcut taken quite often lately and especially often
in DT-based drivers.

Am I the only one concerned about this development?

Thierry

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDLNMAAoJEN0jrNd/PrOhhwAQAK9AjWRaNcZLykAhkqcaoG/f
v3zxgb4k04AIhaYBtzFd6Hbtke+gDZpgCIsRBeitAGPTNxMpu5FcJgyH7iaWr7hw
+E0yV7LvEgoGCt4sTnTA9N0TPGrURV4Zt/9+7nrBphBtadA7QBxq8bmIDEDJ/kak
FlyWDSJIqXQyxzT9vUx6OR4PXjvVqeqykxEhCJi/i09P9WuyFtEEi/KVVIO473mh
FL2gxoU3BWCHcvSY/lt2rnPGAQuzqHWYX2HuPiBbiMeDz6fbHl2NlGybIPnHUcjw
e7SSJ22fV9JaSPOh0O0rGZrmukkJ8B6wNXZhDsmW3rOtT01339WNeJtl0iit2dVz
OqJbGBlJvV+elLa/1ih1g3NLF2J4RT5P421+feCn3QmAMHVA/WZXrhNCR9gQUUOP
3Fnnt6qECL3VmOa/nBFtMj71XJIwsyhFTEceyjp5rxLXKWRtpblIGzrwqYVYYLNF
lRsbhlruWDwRQPtiOaDD+7y4xl/tRJ0giDPLsmFIy290O75kB5Jb8R6ZtQqK0Vkj
FaF9j5Ok61vxkD7T4LjpMseQflAVwPHUhgEeSbx2ol3NWzerheMUwTejsXe67reN
Xbqj9BCLyMu/j4T5WNSVmb1j+QvYmvwwwe/hmmJ645+3Fb4ZACDJOYpp3Q/nGvQe
ypSSJzepvIXh6p9WrBB5
=E9Ke
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
