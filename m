Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab3BKEnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 23:43:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59508 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3BKEnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 23:43:04 -0500
Date: Mon, 11 Feb 2013 15:42:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the driver-core tree with the pm tree
Message-Id: <20130211154255.62c1326a5f4a52b4cc057713@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Feb_2013_15_42_55_+1100__o1+0kim0YMhyuBz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Feb_2013_15_42_55_+1100__o1+0kim0YMhyuBz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/acpi/Kconfig between commit cb2b212bc7ff ("ACPI / scan: Make
container driver use struct acpi_scan_handler") from the pm tree and
commit f756f28b84af ("drivers/acpi: remove depends on CONFIG_EXPERIMENTAL")
from the driver-core tree.

I fixed it up and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Feb_2013_15_42_55_+1100__o1+0kim0YMhyuBz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGHbPAAoJEECxmPOUX5FECPQP/iU8uPhBYvRap6v37BBF4kSy
qwTt76c/OWh9FoQDfbpVlbynNQG1TnVyf9b39YKLf45hb3icgiQD+0U7/UF+4wKw
raVqgk8pcel8OxDjYAhVepIjr8b10T0PzTlJZKXHbkoIRuJnVMv7dOI3q/UqPmen
/fDGO83D++uT7GUDRAGh8qMSio7N2WCPT1dv5Dmomd7EIA2KjnUkgvBk/7W5Llok
/6TDk9mQE+wFFKbKTDk1r3xjSJrbfsy4CiwPco+1wZOkas9OhthhlRdV9kHfyzPb
K2VPFPio0RJXeq10Ohnu+SRJj1sPHSJT3CPwgzeyJqh6elpbUEHhKX3U+TSajjJH
mhK8XO1vbr/mOabukbvV6H+z3FpOdCLfu1vk3xHO5RzOI82wAH//qLem23cz4jOp
hmuU9+3UTJk8RKGQfAf4EJYqzOtFdkbDMdc9Q2GSE14L7NiMbFgQkKnqHmOWHYqj
swnUZNER8JJRnRxYAje6LUDrgbN++hCKoMsH1FU51LmVIp69RHUOPIyJJOfqVqnc
pQTOW7kh6AFeUHpPYdGYeHFZRMzf9odYJfZRlB3Pz84gMXaTlnOPyc0gz7SlBj0S
5u7LxCH+4ZKvQoU/ons0YICxuxSfnpKMc0rhN/hYW1DdA4XHH6UhCliz0nON4x8h
FmEgcywla9pPonIqldX+
=yq0z
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Feb_2013_15_42_55_+1100__o1+0kim0YMhyuBz--
