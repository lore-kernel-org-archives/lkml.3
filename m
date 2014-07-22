Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbaGVVDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:03:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44151 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbaGVVDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:03:16 -0400
Message-ID: <53CED190.8060702@wwwdotorg.org>
Date: Tue, 22 Jul 2014 15:03:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Tejun Heo <tj@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Hans de Goede <hdegoede@redhat.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v5 1/8] of: Add NVIDIA Tegra SATA controller binding
References: <1405500863-19696-2-git-send-email-mperttunen@nvidia.com> <1405667500-7402-1-git-send-email-mperttunen@nvidia.com> <53C8C9BD.3070709@nvidia.com> <53C8F6E6.6020901@redhat.com> <20140718150603.GA7196@ulmo>
In-Reply-To: <20140718150603.GA7196@ulmo>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gFvM3qUNEiBIujkoUOihmKSWH10GoBB3B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gFvM3qUNEiBIujkoUOihmKSWH10GoBB3B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/18/2014 09:06 AM, Thierry Reding wrote:
> On Fri, Jul 18, 2014 at 12:28:54PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 07/18/2014 09:16 AM, Mikko Perttunen wrote:
>>> So here's v5: this time, as suggested, I handle the sata clock myself=
 and let ahci_platform handle it too, leading it to be prepared+enabled t=
wice. This works fine, and allows us to remove the DT ordering requiremen=
t.
>>>
>>> I also have in the works a patchset that adds the name-based ahci_pla=
tform_get_resources function, but that is not quite ready yet, even if it=
 is quite far along. Also, I am going on vacation and returning on 28.7.,=
 so if this v5 is acceptable maybe it could be merged for 3.17 and I coul=
d work on the new get_resources scheme after I get back from vacation?
>>
>> Yes that works for me v3 of all the patches with no newer version +
>> v5 of patch 1 and 7 are pretty clean and can go into 3.17 from my pov,=

>> Tejun can you pick these up for 3.17 please?
>=20
> Tejun,
>=20
> I think the following patches can go through your tree without causing
> breakage through unresolved dependencies:
=2E..
> Stephen, the rest of the patches would probably best go through the
> Tegra tree so that we can handle the dependencies there. I've already
> sent out pull requests for 3.17 today, but maybe Arnd and Olof can be
> convinced to take one more.

At this point, I'm just going to wait for 3.18 for anything that didn't
make it into 3.17.


--gFvM3qUNEiBIujkoUOihmKSWH10GoBB3B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTztGQAAoJEJuNpwkmVCGc7xwP/idWdSGs4e5mhKeFkzHeEDev
jYyY7eBAE92DF5YFVH3a81gmRAjFuDRMm6tx8U46PEbUOygnvRDH0PsNiEQ06dtf
DypZiailwoFwKv3jGBgtpgIDKu0u5WQAadzYn4iDwIOaAjHeYFoh99mpqO30rJFA
jwj9ZFrBbtjF3pjRPEcUv2fxlmab8GIYFtJ9BNrSB+A52Vwns5+u7pefplPGEO+a
v/1LgXh97K8rE9ZHNXX8VQ12nwxvlLpRvySw/cLSPKgmhVdc9lcUArVP6Mn2x5Em
8PYEsDNap6qI/ebriNUH8GSS9+2+AkgSqBMaYbqtuUQlxfVpRwZWNQfXCtgtMulq
YzOnQ/nH0/r5XIRyQJjZYrNEMFZ4bvEoNVPQHRiKzW7dtJXJhr669GMQe2Rt1F9l
YG3OcT0jlBk9RSyjw3VFi6X7WSDhQM+3+sXS77bxSG0DAR/ZXXhFo9Wz4Y6G8n76
BzOlqLZYWa6HLkH49FCzBRZzhZUFNxRs7AymBZ2cLqAWN3G8zTe6qlP/wLu6EsZZ
qpcb3oBXZjbch0NFAwBS/GM0j4nvUdVDbPpdEHsevGSk9JEHIOtCC+xoBMe/gr6z
0cd8FmzfkNkYKEuQW+Ya3m5Yuf5QicxsDlOiVPKQX7q3jZkf6Pru5xn4RhonGDbV
3vDWo8h1+2uH0YygEr90
=Jg4Y
-----END PGP SIGNATURE-----

--gFvM3qUNEiBIujkoUOihmKSWH10GoBB3B--
