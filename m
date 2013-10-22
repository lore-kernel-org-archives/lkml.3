Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3JVOmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:42:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab3JVOmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:42:50 -0400
Message-ID: <52668EE0.7020801@suse.com>
Date: Tue, 22 Oct 2013 10:42:40 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kobject: export kobj_sysfs_ops
References: <52659B24.4030809@suse.com> <20131022060305.GA14982@kroah.com>
In-Reply-To: <20131022060305.GA14982@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="dqWUaJqJ0D6s2Hv3l40D3iJfFbplcnKA2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dqWUaJqJ0D6s2Hv3l40D3iJfFbplcnKA2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/22/13 2:03 AM, Greg KH wrote:
> On Mon, Oct 21, 2013 at 05:22:44PM -0400, Jeff Mahoney wrote:
>> struct kobj_attribute implements the baseline attribute functionality
>> that can be used all over the place. We should export the ops associat=
ed
>> with it. I have a series of patches on the linux-btrfs list that depen=
d
>> on using kobj_sysfs_ops rather than re-implement them.
>=20
> If you need this for other patches, would it be easier for you to just
> take this patch with the btrfs patches so that there's no dependancy on=

> my tree for them?

Yep. This patch is actually posted with that series on the linux-btrfs
list. I just wanted to get your S-o-b since it touches kobjects.

> If so, please add:
>=20
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> to this patch and pass it on, as I have no objection to it.

Thanks!

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--dqWUaJqJ0D6s2Hv3l40D3iJfFbplcnKA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSZo7mAAoJEB57S2MheeWym70P+we49hefyt+sLYcNznJ0w+8o
eiXmy4E4u/aw1jDhz8uZy18w7udCEukBb+SymamoYSrW/lbany4G3Y5uBaEI83o0
VOiAo8WcKCNXpXDhIxCBH8z72ZhYu3DlqQCfXDn9D39c7ctUu0Ke9Gg48zQ4FxoE
Z669qWbQ+QALKHxp164w53wnNK7KyoioBIQOjz1KOexiKrGQLJt9GWK8GUQdrAEW
K1wJzf6pT0U9GKK+b1WTb+v/C7aClW6GHr6QG5IW6Xy/o/F6twbekLCxRSEtelq2
0zk4f6OCq4sd5FoUf8NvPk85Ud5Nq5CQQ2r626/6UQe1o27/6//mnoxGqKYbLpxr
Xe52yre6DtXwMO7O/gXpvMaQY0+qbFcwJPCBskUUSmcBzVLwndIOpaZGBf0NmPu4
YDnInM1wKKIiY6VGXh6j8THEzfBzzLBCarrgIFImab18geltiHMaULNVcX79qDBK
76QbmrqgJST8+DVyNFbwHFMGac3IzR7cc8mpUTJ69Ypvs4bxP0ex0clU/HvfkkP0
hMW89lfillDvB7TdNzza1a/PYUDbxpJmfF8NkG26zmQpNd2whLEXsVau2a4Hjuaw
ZlH6GX1M97CNkRm9i/dXB5AFwyfj8ev2KYXnlZ2PtdD1zYIBGDzrX18fuJMxaBlo
BW+wdWj9He30Y9dhqMtJ
=b50M
-----END PGP SIGNATURE-----

--dqWUaJqJ0D6s2Hv3l40D3iJfFbplcnKA2--
