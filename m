Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbaE2Jrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:47:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46415 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbaE2Jrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:47:46 -0400
Date: Thu, 29 May 2014 10:47:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140529094711.GM5099@sirena.org.uk>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-6-git-send-email-takahiro.akashi@linaro.org>
 <20140528201955.GJ5099@sirena.org.uk>
 <20140529080705.GD29812@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TxukmIqg3MmZ0Kmh"
Content-Disposition: inline
In-Reply-To: <20140529080705.GD29812@arm.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 5/8] arm64: Add ftrace support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TxukmIqg3MmZ0Kmh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 29, 2014 at 09:07:05AM +0100, Will Deacon wrote:
> On Wed, May 28, 2014 at 09:19:55PM +0100, Mark Brown wrote:
> > On Wed, Apr 30, 2014 at 06:54:33PM +0900, AKASHI Takahiro wrote:

> > > +#include <linux/linkage.h>
> > > +#include <asm/ftrace.h>
> > > +#include <asm/insn.h>

> > asm/insn.h contains a bunch of C stuff which won't build without
> > __ASSEMBLY__ guards unless I'm missing something (I'm working with a
> > non-mainline tree so I might be).

> The guards are added earlier in this series.

Yeah, I discussed with Akashi-san later - the guard patch didn't
actually make it onto the list properly, neither of us has a copy
locally.

--TxukmIqg3MmZ0Kmh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThwIcAAoJELSic+t+oim9sf4P/RizGN1z5sqd1R7EX7HXr+ya
PCs95Q9MHDVwgvTPC0SWKGa5rCVv5VjdOJWyK6dh84YIZk60+F4KeC3TqP5SGzKW
4AUAxob5F64O8cZ35+mryf8kIa6+j2mXaLxxMTzqJhgyCSWTJ5ERjoG18yk4ILFg
gyFrdjkDViVosND3MHFkFXlT+mXNYoo3Eo+PukiGVF36qgMi4miXZxv6NBT1pOYQ
vH/xWgtH16/GkocfGFyJTYDzRGdyyrSkl2B/xXXimPizZaSyCBgHjRCpwbh5gd3m
npyJwYE5KFt5zFajgqUqL7FfJ0PNiBlUqU/ZQk+a8yMrFhxTCG1N34Jz+HZcnsJu
Gi0GPWSvXqHZnsVY4G1PjdtNQigSfPCFqVP87rSyGcKnHcJdMO7DqxQuX22nsZIB
VfrGW8H+YQ4a21vCpXCrlPTcim64PoVLlhwMO1ez/GUWTUEI3EHWK1zstQ/fyh1A
dIZd4m6UG9aZBVYkZ9m5inxnvLWEUlm+boiMVj0jPbWJhoanPAIhngGM34uuMeAZ
/rzLMQPvcAtSGffJ6l6WYQ+5JaozZaQjcQGTKAGcwtWRY0Z7ml6mK/DRl09UMAFE
xphE8cydv+s+30IFDRbxq4MNv+3ELeZb3VHM8+DeRH7IRcLC7VWgVSW8CjuDcyBI
3NHrus+d89vkI4L2uHH5
=qyvo
-----END PGP SIGNATURE-----

--TxukmIqg3MmZ0Kmh--
