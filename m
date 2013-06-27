Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3F0GeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:34:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55886 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3F0GeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:34:23 -0400
Message-ID: <51CBDCE5.1020301@ti.com>
Date: Thu, 27 Jun 2013 09:34:13 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 9/9] radeon: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
References: <1372209221-16492-1-git-send-email-wangyijing@huawei.com> <51CAE967.7080704@ti.com> <51CB9ABC.20704@huawei.com>
In-Reply-To: <51CB9ABC.20704@huawei.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2FJOEFOGFUERHPOSURPDD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2FJOEFOGFUERHPOSURPDD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 27/06/13 04:51, Yijing Wang wrote:
> On 2013/6/26 21:15, Tomi Valkeinen wrote:

>> I couldn't find the rest of this series, and I'm not familiar with PCI=
=2E
>> So: is this patch and "aty128fb: use pdev->pm_cap instead of
>> pci_find_capability(..,PCI_CAP_ID_PM)" safe to apply for fbdev-3.11
>> without anything else? I.e. has the PCI core changes been merged in 3.=
10
>> or ealier?
>=20
> Hi Tomi,
>    Thanks for your reply. Yes, it's safe, because PCI core has been use=
 pdev->pm_cap to save
> the pm capability offset already. And PCI core changes related this pm =
init code has been merged
> long long ago(since year 2008). This series changes just to simplifier =
driver code about pm code.
> It's not necessary to access pci device register to get pm cap again, d=
rivers can use pci device pm_cap
> member. and this series had no changes in PCI core. The rest of this se=
ries like for bnx2, bnx2x etc has
> been tested and accepted by other subsystems.

Ok, thanks. I'll apply the two patches to my fbdev-3.11 branch.

 Tomi



------enig2FJOEFOGFUERHPOSURPDD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRy9zlAAoJEPo9qoy8lh71PQcP/AwOQJ+XYtP0frNRRC9PnXeX
eeDKwOYv44R2XPMClTDX2IUa3cDmC1WqUKHpOSap8IXUr8Xta7/dFbbomGC93Zan
HtMrpmlo0QUAOZwzeOIhzn2jxtWxYZZWY3BpJqMokTzsOyuqGftqhaVEwNhpQpif
VUlOQwF+a9973fHcEXN1F0bHH1esNlV0bTJ7quBAZ1D3xYDz0wrxk8J3xaP1Z8dj
7DQpGT5vRCfJrC7tfyKcCZdFYvp4PIxKFJRnQEuKPh7QKIM9cHy9YtgcpGt3NmiN
5IPzl/XdjDx9YN2G25coD3ZmW16tJUJaNq75G3drPfIVloFaMgP0s6lGjhUDuTda
PWED3BZ54CB9TMv9Epsl2rMaN6QKmJhnvpAtKy30Ruevd28DT9PqCSNhXQV7QlNf
VDcLOhPpDON0GaCMxiPJaqS63+w/d8SQb4xPeoPbmf1xEM7EkJLpsHPp/qFv7WTm
CgGcWRwO+o+fYKe7X5aL3JGuI1Hz5fSaTi9FzQwS6BFyFLjBuJkCskAEDvpSSWIJ
K107ugZADlIZsSAJTJ78WW/ECkCISAxjipi5NwA618Bw7k/Krz8OdEZTsDBj7CPX
coiPvgw+VtH3SMlBYP5+IBtP1pOxUHPWZwnJGdRFOxdiSSYMB7W9Pr9vbkgaCBQq
UO4iCTncfQ5oJWbg0yp0
=fn4F
-----END PGP SIGNATURE-----

------enig2FJOEFOGFUERHPOSURPDD--
