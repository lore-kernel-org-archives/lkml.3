Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3AJUVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:21:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50515 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3AJUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:21:43 -0500
Date: Thu, 10 Jan 2013 21:21:27 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 11/14] ARM: tegra: tamonten: Add PCIe support
Message-ID: <20130110202127.GB26139@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-12-git-send-email-thierry.reding@avionic-design.de>
 <201301092123.37491.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <201301092123.37491.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:BRuPxD6Yix4AASVaNkuA5hmjr9w+HeiXy07qpEQ5JYy
 s5vVcQZzzO806wy/M/IE3JKiJkJphbf5QQLIRkNiaoMhG0ECpZ
 BBglqoz/FAAPo8aI+A+RpcWsErAHK0VsqF3zSgadtQp4bFp2Vi
 ymNKWieiAMm3zfAO6d0gXyxzlngJF44CGStbcHl/vQVtjxsL6s
 H5Xy+zgSpyri6oM+09fIvVthJ2tnZ8PAJXQAAalCGzbP7lA/OD
 2GUx3tJKnhpka63mP/PUWXhSKiwnSsp4KXAUd7/tLaYnP3kTXW
 E6/eNS4hZilTKZtpEIrnnhn/GkgrTU3vBx639d4iDa3A5lab0P
 C/quWas7Nuj1TAzq+h5DFfok573BtdMuKzM3rVWt5PYfE9Kmh4
 O0GAWRAwVkf6UdtlHAQHxE7eNm9lelZN6P+ZHTrJCvHDJrlFAX
 dZa7J
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2013 at 09:23:37PM +0000, Arnd Bergmann wrote:
> On Wednesday 09 January 2013, Thierry Reding wrote:
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  arch/arm/boot/dts/tegra20-tamonten.dtsi | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> It's not clear how this one-line patch adds PCIe support to the
> platform. Are you missing the actual change here?

This is really just required to associate a name with the regulator, but
I think I can achieve the same by adding an alias to the TEC DTSI.

Thierry

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7yLHAAoJEN0jrNd/PrOhrnoP/juo2Zm53MQ6LlVa70kC7rW1
LCGYxaQr1AJyxEqlBxHAS4w3M9+HJ9MF2MDUuT3pOm+umRLFcNR0cctObjCTUyfV
6YeT1Om0H1mmHPpgHBi6sM11q8dumsDqePqDNIFiILEK70EzKnUQtOrJ2O8sEnx3
j2twKGBTa2kQL+iyaoVC/2uszEwjH9WE89CVbEMnOS8wFnyyN4lrvB4KSLnkU/77
qzZ6nejKbyF2jMpR0CNK1BFzgBWQGv6pLAnXK4gvKWhfwaYm6+u5CLl/lOsSTCtL
cS49wDotsB92YgQae0i7Gj3ex4+zepIAtPDUT15klhN9g6Dx67IGQLEwsdzHN44i
RXzhqHCDfo6HfM9zTf2LkWWJvpNSYMOvjSDQqQeubeDHJVhbQGp6DTypfUKpeOBh
e5iw6DFDX3Vll7g+pXGIaWnXK/nK4uUVphGBK3YdmiNjPFinnWOeNqrwV5W52LsC
xOo/diDOBVMOBaWPh3AyF1Sd5rAKysxmLpgv9jKCbY2Q++q/9Awac4rgVa2ObTOa
jcn1W6HRDCgFYnwoe8akuOo5NZEOvef2JkOhXW0YvI8hPLKteHAxLzLlYREPWwyF
o+w0vDVlRX0emP4vzsS+j0TuWusv4MU9TkUe5Z+8KN+drqcMfeI1ZEgQlg17GjMf
dD4HO1wyDemBUgul7AZH
=1MWh
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
