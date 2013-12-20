Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3LTHVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:21:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:64281 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab3LTHVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:21:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,519,1384329600"; 
   d="asc'?scan'208";a="427670944"
Date: Fri, 20 Dec 2013 02:03:07 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 02/13] ACPI, extlog: replace open-coded _DSM specific
 code with helper functions
Message-ID: <20131220070306.GA4571@gchen.bj.intel.com>
Mail-Followup-To: Jiang Liu <jiang.liu@linux.intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
	Len Brown <lenb@kernel.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1387457266-4854-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <1387457266-4854-1-git-send-email-jiang.liu@linux.intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2013 at 08:47:46PM +0800, Jiang Liu wrote:
> Subject: [Patch v2 02/13] ACPI, extlog: replace open-coded _DSM specific
>  code with helper functions
> X-Mailer: git-send-email 1.7.10.4
>=20
> Use helper functions to simplify _DSM related code in acpi_extlog driver.
> Also mark initialization data and functions with __init and __initdata
> to reduce memory footprint.
>=20
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: Chen Gong <gong.chen@linux.intel.com>

Tested-by: Chen, Gong <gong.chen@linux.intel.com>
Reviewed-by: Chen, Gong <gong.chen@linux.intel.com>


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSs+uqAAoJEI01n1+kOSLHZrwP/A30PcgUeqVVRCU/mqLf6uab
sqj9neiaegozcHZRJDCBsgHPewCk7FZBo8ZM6l86DLskjvIe9Ix4oMFOUTEq2h8i
NoBmGWtMm5PA+U3qMAKmAHZNtExE9bhEFsLCj6sjA2agDAMQgx2+HAWPlyZ59/af
gpzp5neGlC6aO0NRQpCTvGtEdHXaJYPHtWwy6IXFfAt6WU4oWdxbCJTYYIPfUU/k
PK+drXimbreUxObcrhH6iS7GPzFIuZJKiUF722L4awHPbzRSCPski2+XcEg4HJfr
p2cSlQ/BiZ6hRAEHP/UYJO9/olfgoevUH6JtHc0tlqcB+Fi1LxF+YAVHY15Vh1FH
Fwm/gA4pUMFN6buqmf3UisNz62q295374TinNw4FVP9zsS3vrrMwm+XHozLJoJIA
MKTeU57kpTOl+PQfeSNrN0Yz+Ta8Iz3rLq43CSSx2ClM6aXAuMRxcTLRKZOR/s9E
WEzI3cmEcT2xOeCxooPVfkje1sIFWK1eleZtL1EH3zICtDYPldvXDnGyA2NevnUW
bAQNhTnU+IeQiWL8xoY+QkGy9OgDluxlqrYphHej2/7ukgZzdEt6lWtR75JqoEeP
wxa07j9R02rBZNdw9PvRquhtaRxCTsuUXC7deVbOveQpNBqpCaci+ICq9K0R/jvk
hMXYUyauO771BhaUInkn
=W8aY
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
