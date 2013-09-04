Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934562Ab3IDJ0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:26:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:46281 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934527Ab3IDJ0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:26:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1020,1367996400"; 
   d="asc'?scan'208";a="355717211"
Message-ID: <1378286800.2048.1.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH 5/7] ixgbe: use
 pcie_capability_read_word() to simplify code
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 04 Sep 2013 02:26:40 -0700
In-Reply-To: <1378193715-25328-5-git-send-email-wangyijing@huawei.com>
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com>
	 <1378193715-25328-5-git-send-email-wangyijing@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FzsLmdWGu8vfr7ZgN+tn"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FzsLmdWGu8vfr7ZgN+tn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-09-03 at 15:35 +0800, Yijing Wang wrote:
> use pcie_capability_read_word() to simplify code.
>=20
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: e1000-devel@lists.sourceforge.net
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)

Thanks Yijing, I will add it to my queue.

--=-FzsLmdWGu8vfr7ZgN+tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAABCgAGBQJSJvzQAAoJEOVv75VaS+3OG8IP/iHrGRDmPGoofrbCkgAIj+uL
eCCvun9ymY0BSfGB9Uu9VNB+ryJAIk2H5apldYWeURyoVQxdJVlBJnPTqI3jN1Kw
/DzP+FRUyiRVD9NCW2cRB9ZVzKSlkqOZ/UKtpOwbAh0+rWT/k8T/cvfK1/EMibyh
71w05n1IlXJoDZqKi01M+w3JQJhK3yLwq/pcW4npwxXI864Mg21ExjQqxgd0ABVl
2UJ3LNQ297vfTco4bOXXLtS6Wdtl316iYFG3Ix3YdBK+q5ly4qtHX6UEp1YtaZlv
UMtlEIZu0TDiDzO1srxyroHFcEmB76OmZZnY30huVwx07zbOFP0JuzT4yyWGRIuk
+LBQWMhkJ2c5l74PmejzDfD/Ur4+1dFwi7qs++z2NZJE1IH6L1HZbdPHMm6yq5B8
ZNzV9nsaS0JO6XVJYdtzB/r0jfHhbTuYqYN83eFtW2n6qGYqyj/K+mm1LVJ+WjmS
HTsJxbElwVPbJbt8s7OUNt8EFNogezIiPGzqUAx6+CVHAidN5cxxsu7ueF6LLLNF
MgjlZrWL9a/1mi7pco5JMSLUaQm4Ej3vAm0u2W+hiSfWuNKG9K/9eHHkFqiL7747
A8xDvnxfpfZPKyK97miOeJAL+GXbndeVcjqdNAAc8AW0Q8OuBQcqYmsqyeqIHFWd
+s2B/j2TWlba8UnxQdRE
=YYqR
-----END PGP SIGNATURE-----

--=-FzsLmdWGu8vfr7ZgN+tn--

