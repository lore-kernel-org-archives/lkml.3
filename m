Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898Ab3DCRmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:42:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47908 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759397Ab3DCRmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:42:10 -0400
Date: Wed, 3 Apr 2013 18:42:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] regulator: ab8500: Remove set_voltage_time_sel and
 delay to fix build error
Message-ID: <20130403174208.GL11305@opensource.wolfsonmicro.com>
References: <1364956243.1328.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NZiXfHLGvOGtDZMn"
Content-Disposition: inline
In-Reply-To: <1364956243.1328.1.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NZiXfHLGvOGtDZMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 03, 2013 at 10:30:43AM +0800, Axel Lin wrote:
> The delay field is removed from struct ab8500_regulator_info in commit 29234928
> "regulator: ab8500: Remove set_voltage_time_sel and delay setting".

I've now finished applying all Lee's outstanding patches (which weren't
sent to the list...) - could you please recheck if the first two of
these patches are still revlevant and that the last two are addressed
properly as per Lee's mails?  Thanks.

--NZiXfHLGvOGtDZMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXGnlAAoJELSic+t+oim9MYoP/RvcvddAg3sHaHFGH/lHdKOS
gQKPmUlTcvE3XvBynjmTZLTbS6Aaq/i0lAFZhnjmBpaqQJTwcPahCFKVT6YIhZz+
XUa9q1KjufLUPrKlHkNK4g7kNmF1N6QMA9S0f9bzmrN+My1sjUgmrCpOxFmSvajQ
BCd+p/dvhroLW7nk4pB8/EUUF2jwI9uS3YRiY/NsWSsRwjg9MqzBshz0TA6K09PM
qVQ8dvXs11LYBZLgRwxouf70FpCoTd5zx6/ZtPmlemYNnLj5JbKUBT/eL8C2kKgG
lnAPQ87mRbiWipvrkLPR48gFQuXyenfrwafMITXeOVVy1kFsPAUmlsGe/TeIJBg2
U4pNWNzHE3CupoikVbsjqMHGGXIM37hGBCOTN3SQ5XANZyQ/YfFDQ22Zgz3BHtqy
JGMsU2QPPih8vKSA9VIcUeJu0cj2jcUY4BPSvGVh0ZSbRwge36beGtSX9i5U/tB7
QnZUJ1ShHJw6TSkRiTrVBRQ+pV7a5jq6E76h6u0NhDn+MEkyIfh1u27wwJ5qwbWb
na8JCGF+As4qprZ1PswoSn+PbY5sgxaBIWYqZVywbNFMO51J4cMV19EH1hP5YONi
Cv98Qqpas8X5Awx4DBTTWG9g7vpYNDBYDsGmv6rmTDEfm8l7ArWcEwn0WQr/YGgj
S7q4sXqwerIW/1vjAa9E
=T2Z4
-----END PGP SIGNATURE-----

--NZiXfHLGvOGtDZMn--
