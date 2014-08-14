Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaHNVDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:03:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:42453 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbaHNVD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:03:29 -0400
Date: Thu, 14 Aug 2014 23:03:24 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] power: twl4030-madc-battery: Convert to iio consumer.
Message-ID: <20140814210324.GA22572@earth.universe>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
 <1394052739-8589-2-git-send-email-marek@goldelico.com>
 <20140305232513.GA9542@earth.universe>
 <CAAfyv34X1naNEyht0q+bD3QUjCxLJribmfWfZkP073WS7ve4kA@mail.gmail.com>
 <CAAfyv35Hi-aE+SnTiN9O39ANi63gkNMz-Bz6hqCkkxJARSFcOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <CAAfyv35Hi-aE+SnTiN9O39ANi63gkNMz-Bz6hqCkkxJARSFcOg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Marek,

On Mon, Aug 11, 2014 at 09:52:52PM +0200, Belisko Marek wrote:
> can you please take this series (I'll post update version with
> removing debug code). Thanks.

mh. I will not pull this with "(dis)charging-calibration-data" as
DT property name without an ACK from the DT binding maintainers.

I would feel fine with pulling this when they are prefixed with
"ti,". Otherwise the series looks good to me.

-- Sebastian

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT7SQcAAoJENju1/PIO/qaYAMP/jFo7UTndc6r/VmLDLSLBoTK
zJuCkjL9720eX/vGGDYG/SkWMUzZtvn3NL9eU3lC9FBXdkYhIRKRFBzidYnRkms8
JceS6BJsWa1S6RcEReFVK6fbzOCUTNCzR+HkUn+foc0kuEN/ChhffJXIBrDMGGGE
8TBYSYYPvsADgQEc/po65kWVwpdg0dVkQXD1h7o+Xp0JOpOM3BPi0ESKwCxSLCJS
CJEgwSrPO0NvOGT8vr8d8DbRa9esXnmfFCIuPmQQMURDuWiu4dWREGHkwniLC5yv
t3A/lt69O9ffUM5dlI2K9q/FKp3HSrPfGtHdtVZvoMS9uFDRsYB8zbDSxcX9dUMU
jMWVDNVRbbrRBmW6gqhNs3zLoUGs3rsoVEQEP6i46YyZWoDVyXNNPl+ERRdx4V4v
Vrw3KVr/6nKhrJWJ1Ml4YnUy1HmuF4xEDuNtbpYKbIw4vrRp7AiD0AFEzRMkz1KW
RIHxr+UxTlaOKUUfhSE3GUvmEn0cmf6dEBEdu6fQ1fIhC0VjIJeknnunjKuT0C0G
Suy8uJSbZRQalXvXdR/hDGGo/B2IZfQTLYIXUj8wG/k/gsEjtbpNcHihc8tgI/yF
LKnjJRXWghaJ0NhODj7NllQt4tsS6fSTE5yY+bhPKFDT1c/RoOyNkYFWaj1ZO/o2
2BcBjnOnkPBrBpIicCa4
=3rK3
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
