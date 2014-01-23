Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaAWT4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:56:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58754 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaAWTz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:55:58 -0500
Date: Thu, 23 Jan 2014 19:55:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-ID: <20140123195553.GN11727@sirena.org.uk>
References: <CA+V-a8t5PWv95mr3VCjRamC4gJFLJbh=K+ZA81uEeMfGh7k-1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwtQuX191/I956S7"
Content-Disposition: inline
In-Reply-To: <CA+V-a8t5PWv95mr3VCjRamC4gJFLJbh=K+ZA81uEeMfGh7k-1A@mail.gmail.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: your mail
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwtQuX191/I956S7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 02:36:05PM +0530, Prabhakar Lad wrote:
> Hi Mark,

Please use a subject line for your e-mails, otherwise they look a lot
like spam.

> So currently I am booting it traditional way (NON DT way) and
> regulator_dev_lookup()
> fails (return NULL)  and for this check it fails.

> +    if (ret && ret != -ENODEV) {
>          regulator = ERR_PTR(ret);
>          goto out;
>      }
> In the NON-DT case the 'ret' is never updated in regulator_dev_lookup().

What is the problem you're trying to report here?  You're describing the
behaviour of the code but I don't understand the problem.

--wwtQuX191/I956S7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4XPFAAoJELSic+t+oim9tagQAIRDiP/SwUVIBcmHK2uCqvgq
Rl0vb/c2cGwRalTWZVhl2gEOFPVZVdXwhEm5OmqvZC8jzOZv648B0ryx/00ztbrU
Nu0QuT+GwMgzC7o6CDaf4JsC6K0yavMAoj8O13ux7k0amwG5rIbeungxwaERR1LL
BC1rq3IfbdJ92seOkKRhlAUHvS2HFPgHWJFwMEKTHxOXCFJ/c2XqqN6NosRgDsPP
slFw53HKW45mx212K0X5sFPJORNXYc5kt096F7ZpWQSJ2l1GQaDlVMroPkqpryJ/
tFHlJ3RtLFP8KufnYK8JjQwILc2ZCyTR39D4RpAzL5CuEHJgKar3ve+XF5MylGpt
Y8dtxMFaQpKvO61ODW2VQKFHcM6jdvbqAtselSusSmIhOuq3TXjblP9nLaIeEYeF
ZLeQ3GUoouxiiKLQN95PmuqgUv+znHq4hv1qHcZFeSS99yeDjEjZwvCu+VGHbvOs
ow3GIQajS6REo70BIqqszXIRd80J94px/Iefu45q++DFJxKrxJ/YwhlTBSJT/hnw
MIgzlFw+MnpXfRzz9LuDgyDqIrXoAWZ9A9DDSnWYx+2UN5d6cQj6KqOocUOquKC0
KKCgTqiqrSBbQiyJJNWPMTQ8/Prfm212ZSLTXUulSF0ZcNDI7kfv6Ij9Y8rRHl9f
Wdie1zn4uC5xtVDMQVZX
=0Esv
-----END PGP SIGNATURE-----

--wwtQuX191/I956S7--
