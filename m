Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3DSGqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:46:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40118 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab3DSGqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:46:44 -0400
Date: Fri, 19 Apr 2013 16:46:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: build failure after merge of the arm-soc tree
Message-Id: <20130419164636.0d2405ca5fd927f1ba31fe40@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Apr_2013_16_46_36_+1000_dI5P+PfW_KVhrBgQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Apr_2013_16_46_36_+1000_dI5P+PfW_KVhrBgQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the arm-soc tree, today's linux-next build (powerpc ppc64_def=
config)
failed like this:

powerpc64-linux-ld: cannot find drivers/pci/host/built-in.o: No such file o=
r directory

Caused by commit 9ecbe03ae85b ("pci: infrastructure to add drivers in
drivers/pci/host").

I have used the arm-soc tree from next-20130418 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__19_Apr_2013_16_46_36_+1000_dI5P+PfW_KVhrBgQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRcOhMAAoJEECxmPOUX5FE56UP/jEsJfqzf/BntE6DhkKUnHYw
XnDFAxk/8pW0GMTd8iwqSqitmdtPutViX5BtO36m7abiYA9OJyTl1rYaELpSFeGU
kE0eDAXZamCdGc+/A7sDWikl894kCD7XLC+UxFDq9JAeiaxiKB7tRwIzEvhrhZGK
rELP1FDkDPY66NiTRIC+D02qs8gGNNLtBxJOqYHEhpJCXNXF/ImAkhaBnct8PUcF
sGDSyYODP0cODsdMzA7z5nqZZDfZAGRovXrtIycAN6OibXHv465f+xfXUyg8+K70
f9OwdnyktrQoOrXaYpHy+c947kC080AaPT3vrJIiqBRhK1sDks8v2Fov0rgO7t8y
FzZemWqBe5MQPX+KJqRrZLaYzgPREVR7hvVGZ/sz/U804nMG8atpgQh/lKDF7cBz
qJb53uL0DKrDKIP3R0rlzaBDLEGjenKVvQzBYPkjFbdtX75ZqjILhfx23Z7MIivU
EUqcrakyrMFyV92Im5S4XJrJW3IJX1TwWPL1iDNSgpfpdxiDb6adk3X1N8eLsF0+
OJP+VPWg2N8spuj7tRPseXdN0AiQS4UPNCugHoAIuSJdz41Uemxfm+vGszlnwE8W
pljGP9E+umBoqxhRXM5fX7SWq4ICtGZaE6B29KyEBe7dpgC+sV+iWpQPAEruH5LI
WpQ9y3O6M1LEsmvYnehK
=4N0v
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Apr_2013_16_46_36_+1000_dI5P+PfW_KVhrBgQ--
