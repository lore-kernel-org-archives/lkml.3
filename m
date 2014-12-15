Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaLOPZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:25:44 -0500
Received: from ring0.de ([5.45.105.125]:59532 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaLOPZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:25:43 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: ring0.de]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 15 Dec 2014 16:25:39 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HSI changes for 3.19
Message-ID: <20141215152538.GA22778@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

I have a couple of small fixes in the HSI subsystem for the
3.19 merge window. Here is the output from git request-pull:

The following changes since commit 58586869599f6bb38aeca71a847cd77bfea74808:

  Merge tag 'pm+acpi-3.17-final' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2014-10-02 18:47:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git tags/hsi-for-3.19

for you to fetch changes up to d95dc9e388104488d0f5a5969c435e601840da2e:

  HSI: nokia-modem: fix error handling of irq_of_parse_and_map (2014-11-14 23:39:40 +0100)

----------------------------------------------------------------
* misc. fixes in omap-ssi and nokia-modem drivers

----------------------------------------------------------------
Dmitry Torokhov (1):
      HSI: nokia-modem: fix error handling of irq_of_parse_and_map

Michael Opdenacker (1):
      HSI: remove deprecated IRQF_DISABLED

Sebastian Reichel (2):
      HSI: omap_ssi_port: Don't print uninitialized err
      HSI: nokia-modem: setup default value for pm parameter

 drivers/hsi/clients/nokia-modem.c       | 8 ++++----
 drivers/hsi/controllers/omap_ssi_port.c | 3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

-- Sebastian

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUjv1yAAoJENju1/PIO/qaiiEP/A+AksGWF54bSBe9ju93WzJ3
N1VnQdq9HcsnpURgSJAExWt2BX3L7roewt0BzKzjtzP6OCSlvSnq7WYbcwsCs0GS
w/pqNZJVjSVIou8mUIibVTeVtuIqSmJbHGAU+9S/rB6w1AZGiaFF0Jr6zChdJGwd
X5k9AUjcfQsCUThhoNJnmPsxb7OV6gmAhdqUJmuWwiJeodOk4lcx8qYaw+D+Ed0z
WeBiT1Fqg2YNBx6ejNY8mxOkGRTsYwBapCQK8pp0PZ7+xfzMSGN/H0aNvidzgBk5
Zx+mTbiJIgGqjAra0f3z+KvrKwgLaxbf/sv5AnGKZStaTvnvo3geqS5Aa4awMaZN
pvAOvSPz+5SAvmc1aPgC+LqG/YE2QhtzgSPlAzTC2ueLn0oZ4t+YEnaW0t59mY2X
HZzzzXxtAfCOprSUXCV0b/9LOaVqWZ+YZbW5b/UjK9RkMZUfD7+32wNhadCPleyl
xUJQNEtxqmIWRkGAvpiIaPDtofrkWwm9wNmsKtqk+n7xW6XbYn/IBKBiahj84SA7
NLG8rhKhDHSZE8QsltjFTBxOP16BCfPrD4TpkKinUPVyNeIvMG26I4lNfVmUEJbB
9XH+y32iQOAApTOE22fsTWHzN9UnP+YLCRV2pdKFTNgqZjIQqyuaphOHyAG56Uj9
mvVYKhcuswQ1SNoyemwX
=je8j
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
