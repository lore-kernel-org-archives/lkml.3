Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaBRB7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:59:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58301 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaBRB7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:59:52 -0500
Date: Tue, 18 Feb 2014 10:59:40 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140218015940.GA2669@sirena.org.uk>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
 <1392627817-26957-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="07KgZKBWke2i7lgQ"
Content-Disposition: inline
In-Reply-To: <1392627817-26957-2-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/9] regulator: as3722: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--07KgZKBWke2i7lgQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 02:33:30PM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--07KgZKBWke2i7lgQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAr6IAAoJELSic+t+oim9SH0P/AwSToOjbV6iI0Gmz8MUTeij
Uea+TBZp0ZIDHeorai+68P8b1pnnD3qWAwEm6OsIm5zA0GxZa/0hrNPN9IJhX5if
UgH3gplBZXr+EuJ72Fesv4FSYMSmyFyoGZyen6Ipq2gk5MKH3yAVQyl/fHgTrrfW
F/sR3GMkGYy+xm3TerzkqsdxmBp8zgy2zKGzQ4jg9/d2HKeZ7T6PpNmu5Q5GsdJ3
VEw8mvXT2qYB/8T27+Xi81iashQn/7ypyt8khHMCukaXaTKHr3SOKWlI3WJzguRB
IatSw0oYp4XKFblmVgUBb2GpEKNibREfA8iFL57O+6JphEDlm5VN1srzdDy+/HvZ
LH3Fi4DqJi4HjkYcAT0KFmUaxMdEgrfh2m+ol93h19+sDnAAVz6S8yYtB0LOKvwg
d4IX9O7Nv2JF8tGe5r2Pjo5NY9uDhkiYqS3v/nS/dWEko86plc2e3paZ8EJ1Dc7F
9lvoFFkEtmTeYWWZtUHLkWJ0ARBZbIK8qJ0fwXjgNMxxJHTNSthI4F7CL+gZEEI5
Vie5+rFl4Byv8dCtWqFdMFTNGnA2cBiaGS05nyOO6R/GUUwghPHYSoKh7fNxd1ka
J/hz6B8UPKyZ/bjwQDYnAxIWtTx2Bhk4AfjpDNvWMikJKW3l2PnJC1Zt3KZ5rl8Y
+PRMGMBArhPBFhEUBEJF
=UTa4
-----END PGP SIGNATURE-----

--07KgZKBWke2i7lgQ--
