Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaADBvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 20:51:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:53793 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbaADBvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 20:51:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,601,1384329600"; 
   d="asc'?scan'208";a="461464032"
Message-ID: <1388800272.2275.7.camel@jtkirshe-mobl>
Subject: Re: [net-next] pci_regs.h: Add PCI bus link speed and width defines
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: David Miller <davem@davemloft.net>
Cc: bhelgaas@google.com, jesse.brandeburg@gmail.com, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, gospo@redhat.com, sassmann@redhat.com,
        linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com
Date: Fri, 03 Jan 2014 17:51:12 -0800
In-Reply-To: <20140103.204826.924684292174040714.davem@davemloft.net>
References: <CAErSpo7TJXTCxpFKWXLTaHmqXXnYQdnpNeWt+cehSaES2Jh30w@mail.gmail.com>
	 <20140103.193008.684316024702680161.davem@davemloft.net>
	 <1388798859.2275.5.camel@jtkirshe-mobl>
	 <20140103.204826.924684292174040714.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BXTfQvhXaAdBDn0qA9FR"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BXTfQvhXaAdBDn0qA9FR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-01-03 at 20:48 -0500, David Miller wrote:
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Fri, 03 Jan 2014 17:27:39 -0800
>=20
> > What do you want to do with the current series of patches
> > (mainly the ixgbe LER patches) on my tree?  I know that there is a
> > thread going on between Joe Perches and Mark, but it sounded like Mark
> > is working on a follow-on patch to address Joe's concerns.
>=20
> I want the LER config option removed.

Ok.

--=-BXTfQvhXaAdBDn0qA9FR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJSx2kQAAoJEOVv75VaS+3OsBcQAIFtIvX8tivJfLPFq4jsxl/e
KIkY0PoRFMfuAARBRYOjw+uqhIXVr4r1CuJTCV2taqUDGY0n0o66+uTGwhxi8TfQ
a5dbs3pJnEH2SOmpB3fQXUerLrU2QYhoRk6WXNi5LMOzJ20AFesIN5ruNX7hRrnr
cBr+PcbVcCeyZ5tFYu5HST1dceyIDJSEFI5Z8osRr94eJgit/Z2DX78E9474rW5m
4frdS5cfdgT/2CSyQPhOF/a6iRdwTgC+bRFsKVGtKh52Zb992Li+Sp9wP6HVWbsE
V787F83M34TOiyAQXovGvZE1VWb+dvgskw9VjBV7chRh2Frb3a6eS0NCujR3i1hY
yJzxFteHo3OnwiNeFPlsBtDElh/MwHcSQfSRNMcpOppD0BTh8bAYkaK7E8UitRik
V+Wz7XND92XxDyWnkVmZtdCeWGYakofdVlrdwgHDFMmkBAjzD7oWAorbKHXYI9td
x86g2oCKV9C8TGos0uFFWvKEF9ICDYoNFWosixzA0IGNVwhdySQp3H4kAb/eW9kp
mrZQtsVAwy3zYjSFaWYplDq6kalmGFn3S4T5cRqIbYWjTr8CbmUj3yO0gkgYRa3U
lu1Z8lgwXM5dE4NIoqRX1sHvjT+/3eZgMQlvmHAFEA/9D6CUfbjtBUPK6uF1OFlD
3nCWD5jaUQM4WatYB71q
=/dO+
-----END PGP SIGNATURE-----

--=-BXTfQvhXaAdBDn0qA9FR--

