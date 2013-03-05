Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3CELdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:33:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:49253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3CELdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:33:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,787,1355126400"; 
   d="asc'?scan'208";a="299225697"
Message-ID: <1362483225.8626.26.camel@jtkirshe-mobl>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Date: Tue, 05 Mar 2013 03:33:45 -0800
In-Reply-To: <20130305112737.GE4881@pd.tnic>
References: <20130214191234.GH5700@pd.tnic> <511DF7B4.8060504@openvz.org>
	 <20130215091641.GA14387@pd.tnic> <20130304215056.GG22274@pd.tnic>
	 <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com>
	 <5135BDF9.3080102@suse.cz> <20130305095821.GC4881@pd.tnic>
	 <1362477768.8626.14.camel@jtkirshe-mobl> <20130305101437.GD4881@pd.tnic>
	 <1362479341.8626.18.camel@jtkirshe-mobl> <20130305112737.GE4881@pd.tnic>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1Xs+iDRXy7lJEGuLSaWe"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1Xs+iDRXy7lJEGuLSaWe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-05 at 12:27 +0100, Borislav Petkov wrote:
> On Tue, Mar 05, 2013 at 02:29:01AM -0800, Jeff Kirsher wrote:
> > On Tue, 2013-03-05 at 11:14 +0100, Borislav Petkov wrote:
> > >=20
> > > On Tue, Mar 05, 2013 at 02:02:48AM -0800, Jeff Kirsher wrote:
> > > > They are in my queue of e1000e patches for net and are being testin=
g
> > > > currently. I should be able to push them upstream this week.
> > >=20
> > > Right, if you'd like me to run them here too, let me know.=20
> >=20
> > Any additional testing is very much appreciated, so feel free to test
> > the patches with what hardware you have.
>=20
> Yep, it looks good, machine suspends ok again. I'll watch it in the next
> couple of days.
>=20
> The only problem that remains is this:
>=20
> [  103.137024] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3co=
ld
> [  103.161032] ehci-pci 0000:00:1d.0: power state changed by ACPI to D3co=
ld
> [  103.462328] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Con=
trol: Rx/Tx
> [  103.462342] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
> [  108.472847] Uhhuh. NMI received for unknown reason 3c on CPU 0.	<---
> [  108.472850] Do you have a strange power saving mode enabled?
> [  108.472851] Dazed and confused, but trying to continue
>=20
> AFAIR, Rafael said it had something to do with the suspend kernel not
> picking up settings done to the main kernel on time. Or something to
> that effect, my memory is hazy.
>=20

Would you like me to add your Tested-by: to the patches?

--=-1Xs+iDRXy7lJEGuLSaWe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRNdgZAAoJEOVv75VaS+3Oh5oQAJhvejzIbY0DcfjsrDE5lomd
SQYqgm1Obe78xMRMsFG+mU79BUKRJnnDNzRKECvfI5Yq6FXwCslKHRz8dDwgBNO2
EjOdexzpx8sAXpoFedr1KE57SNq7bOccMd+205gWUAQ9O7KXS/D+Br3uMO+Rt6hG
XWgtNFiMcEUC369lIRWTAYcEUeXuAhZAXMUbu4RzX9gJ5yr4HjcfVki4QrbCehTu
eQ8YTf5mkVAJopr08Ls0LRamn7WskvUCyRfN20K7vD0hCwBoRyG7eIhCHyHmEqTn
ZwiMFYQx7L5/ZQmw3Pk8eC8jTZQFSizUo0uQuWItFNANDrP3LI2mUnZb1TG5ZtGo
Z1Twc+VYmmuZ3Huf9olfcb6+UX/XlAuxpQ6xxYjmqitemixIEx4/1/f1irnxjMEh
koH0GgtfL4/qfVUQTSi2wj39NBuE34w3alVXE0dTTVZckagWcZjJLDWmkAefFj8G
DjiE1metpWo6TkXFC4R/FKY/8ipnAH3GxYGmKDLXF8ZJum8gJHqHEnd/zAhVrowT
cNuQRuLLBWGzZ9ew+3rYNZGCF1OBa07ZKIWC+7Cfll5khHoOigKiSqY14SdLUyIw
XmXwSU+K1/HMDFH4TrrXqg4p3vV6OJQlmF9AyGKvKIKRFzxeGepQq674cCe8Qca3
h7QO3siHLCcxYhnSjor9
=Nrfh
-----END PGP SIGNATURE-----

--=-1Xs+iDRXy7lJEGuLSaWe--

