Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab3CLSbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:31:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50908 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932470Ab3CLSbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:31:15 -0400
Date: Tue, 12 Mar 2013 18:31:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] spi/pxa2xx-pci: correct the return value check of
 pcim_iomap_regions()
Message-ID: <20130312183113.GI19942@opensource.wolfsonmicro.com>
References: <1362477917-24904-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zgY/UHCnsaNnNXRx"
Content-Disposition: inline
In-Reply-To: <1362477917-24904-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zgY/UHCnsaNnNXRx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 05, 2013 at 12:05:16PM +0200, Mika Westerberg wrote:
> The function returns 0 on success and negative errno in case of failure.
> Fix this.

Applied both, thanks.

--zgY/UHCnsaNnNXRx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3RqAAoJELSic+t+oim9mtoQAIVSd4wMuH5Nv++VD7npgBAM
5aGVJTJFYzMBXryzNSg+9vcBFqEE49KtbnAdn0ATLA9RAXfVR9VrBJEr9OCopQjS
OLpkQ3IRkZnDxIPG6YstQLC5Jl0lggzhLB8n6Ht0TVPLkwHH8NBEp1MsXeyOHx9o
A/gbLNitsXDbWwHxNCzDjqhvudefFn4wS5ZE5eGjvqd4oHDtX5JFuOCtdAEJyr28
loZV7TlvFoANG0kJN6oaskZqhrTKDljgmeYBIhceqRaHENw8H+ThOpRwpm3t6aO4
Wy9j4bpRoiT2Grbk2uXePq/fsVyiI+wLOH35J9G9XELX7wYGn4su08njuRFiEi6Z
fDRhqYC3OCBusyV9sOUcvPh4X4HUP/X2E/mIcBrl3s8EniwApUhpggsDGc7RLxCL
NQATMMBAodIPphcrT6dz7J/Ub7dg8509qw4ycuSjx+gCdmxe58eQ1VPuOKacMq9E
f1m0VTXdnErBuB/ubPRx4bN/Nl44Uh0o1abXG6GYACV3UU9jms19NHw1f4lRKZ7W
gElHavyAbDQJU/zTqN0cvb+gI5gbQvCmdh9NlntbVbqpLxyusXXS1/PoNVjkpL20
S1PDsoezpzjp5XWqAws4dqOVDWNI7vR6VCWIz3T4eUiRzjQEBsr1kb5k6/1ZbSxN
viIBA2FXPiw0QbVWFmuA
=J6tj
-----END PGP SIGNATURE-----

--zgY/UHCnsaNnNXRx--
