Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3HBKQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:16:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34897 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3HBKQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:16:24 -0400
Date: Fri, 2 Aug 2013 11:16:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20130802101621.GK9858@sirena.org.uk>
References: <1375431557-3096-1-git-send-email-zonque@gmail.com>
 <1375431557-3096-2-git-send-email-zonque@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I2PCQ6520rxrXXei"
Content-Disposition: inline
In-Reply-To: <1375431557-3096-2-git-send-email-zonque@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulators: max8660: add a shorthand to &client->dev
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I2PCQ6520rxrXXei
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 02, 2013 at 10:19:16AM +0200, Daniel Mack wrote:
> No functional change, just makes the code shorter.

Applied, thanks.

--I2PCQ6520rxrXXei
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+4byAAoJELSic+t+oim9bDAQAJsCNH+KzL/YgBddboEt35fP
z7EoGyxFFo+r6ye+h2mbaVyZ5UoWpmnH2JxNtqu+x7jf+oq+gKYKofS0wdtzPZfB
23UQ3opw59NShoDCdkiA985IJ35DxsGxYk9AecmLxyLoS8r4cTto37SnVbHAVXrN
MzFuSRUBIeGO2BlDx0XGFDi+f1sMVuTXG2eheykQptTTCRKBglvvIyjZlW2bCBR0
OoPAWxSZf6n3d0gMwZyzwW/ACJWeqz4aIy0KLTf8YfYxMfcUOJSRi8shcJiwX/aj
aJygH7Tuo+6BlSvLeP7nFardv3fGsRdgXnlf2A9rmc6q61GHhRqYxtZSCmdPC0ZO
WpQHuWOqc7XDwSrLD6pUp4h991H26DDDYdHLMGcTBU7B28XqFhE2EJEaXXYKtIQ2
gVoFboU29S1bActuMO77ZM08BfO7P85tuiKvABjktjxPWeR8cqMu1wkJ6Ki93kI0
QrFfZ2v1IppTleNtTg6ciOP5gDF3XerAF43WOCBNealXKj3NEl/MDq404K1os7qa
fC4NAqE2cq5Ln4ghgOV2S0ehkIbaDWB4BhSXGBehN7DaAMNM2y3jpb56PX6QHb/l
EW/ad/4MU3YRw9AYRlCoKz/c/bcLj3cIYaStavYsp1FKgyvaHoAXtw96Tj2Wj/TI
uIrOy64cC9HcA8UPEd9+
=lW/o
-----END PGP SIGNATURE-----

--I2PCQ6520rxrXXei--
