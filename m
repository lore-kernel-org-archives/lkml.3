Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3FJMtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:49:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35822 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3FJMtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:49:50 -0400
Date: Mon, 10 Jun 2013 13:49:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Message-ID: <20130610124924.GU31367@sirena.org.uk>
References: <20130601184511.GC16790@sirena.org.uk>
 <51AA456E.3030307@nvidia.com>
 <20130601210511.GT16790@sirena.org.uk>
 <51ADAE78.4050900@ti.com>
 <20130604093816.GY31367@sirena.org.uk>
 <51ADB6BF.6020205@ti.com>
 <20130604100511.GA31367@sirena.org.uk>
 <51B5A14E.6000500@ti.com>
 <20130610100330.GO31367@sirena.org.uk>
 <51B5B268.8090908@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+FCZ/OAtUJL4xmK"
Content-Disposition: inline
In-Reply-To: <51B5B268.8090908@ti.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R+FCZ/OAtUJL4xmK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 04:33:04PM +0530, Kishon Vijay Abraham I wrote:
> On Monday 10 June 2013 03:33 PM, Mark Brown wrote:
> >On Mon, Jun 10, 2013 at 03:20:06PM +0530, Kishon Vijay Abraham I wrote:

> >>SMPS10 has two outputs OUT2 and OUT1. In order to connect OUT2 to
> >>OUT1 we have to set "SWITCH_EN" bit in SMPS10_CTRL register.

> >Is that not just a normal enable?

> IIUC, normal enable should be when output is driven through OUT2.

I'm sorry but you're really not making much sense at all here.  You say
there are two different outputs here...

Please think about what the hardware is doing and try to map it onto the
APIs in a coherent fashion - pasting in large sections of dataseet isn't
usually helpful, the goal is to map it onto abstractions.

--R+FCZ/OAtUJL4xmK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtctRAAoJELSic+t+oim9OGAQAIHoba60tGMEdVWjeI5lPcFf
INDFYOdi4fIo5NUsnECCRJ/ipwPk9k6Ec7ByW9UPCzisM3hUWdVMFXNJU/p9D3FY
Lbx23PEWJmLDHgYnq4+ofb9X4G5rW58V66CIu4bPs4W3V40kXlDB7QOoBHvIWWh7
rOnkyKB/qAl8wUtrhcbnlBDcBvz+XlXpJckiOeivEcoU9vizD3HWHnTcd9GiIBK9
EnR+UxusK/fdXkdyzTVM8q3rX/JBhEf7aauO5odkvcynoRFhcgYA2XjZ2eJLkoE5
uRzzZ/ui7yXWpSPYQya5x1QP/7dsSLysUWGfeCWp5CNfAqoasQAELLebtp8GZozx
A8pq+1H/YulDZvJMqsDSb0t454AIhhEPAUTZTdmMmP3rod5SjMTQH0gFFMgY4RT5
9Iqe61aD6YHvHsNmZi2CC3EMEX6ojndiURLJrBzk0NKiQg40q6lzYJhW9BQgwOHY
LSz9Oc/kzZdDoA1/7OXMxbKswByjFirmEfiLWpq8Kzgr6ZtuLBfnIEyX6+rDfQil
n2uH4hn3AJh/p3TLZ2heU2lKm/xyQ6/Qfplej/8z9YgeREZ9l2K0REz2TPZ/MPVi
dreO6TNkkj0Wt/SWYKfDYk9TkgXIOmnVxQ1CJUlBsKFDOPAqOzTe5fXwlKmKi658
mvtNABQZWIiQtBRHKgNq
=OnYL
-----END PGP SIGNATURE-----

--R+FCZ/OAtUJL4xmK--
