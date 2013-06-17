Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3FQHLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:11:03 -0400
Received: from sauhun.de ([89.238.76.85]:59627 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab3FQHLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:11:02 -0400
Date: Mon, 17 Jun 2013 09:12:51 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] i2c: vt8500: Add support for I2C bus on Wondermedia
 SoCs
Message-ID: <20130617071250.GA2957@katana>
References: <1371246736-5460-1-git-send-email-linux@prisktech.co.nz>
 <20130615111817.GA2938@katana>
 <51BCE39D.4030505@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <51BCE39D.4030505@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 16, 2013 at 09:58:53AM +1200, Tony Prisk wrote:
> On 15/06/13 23:18, Wolfram Sang wrote:
> >On Sat, Jun 15, 2013 at 09:52:16AM +1200, Tony Prisk wrote:
> >>This patch adds support for the I2C bus controllers found on Wondermedia
> >>8xxx-series SoCs. Only master-mode is supported.
> >>
> >>Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> >>---
> >...
> >
> >>+/* REG_TR */
> >>+#define SCL_TIMEOUT(x)		(((x) & 0xFF) << 16)
> >I assume this should be << 8 since all regs are 16 bit wide.
> >
> >Fixed it locally and ready to apply. Please confirm or send a proper
> >fix. Rest looks fine.
> >
> >Thanks for the submission!
> >
> It should be << 8. Please apply your locally corrected version.

Applied to for-next, thanks!


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRvrbyAAoJEBQN5MwUoCm2vBQQAKMXsKX7pUN1fcqIfwnzAJgI
kUTY1Bbw7R2xlghCJBkczp/Ici+SStGX44CaJUF/7pMaCu+dphByI1fFCYp/5fYc
kbHFWFpXXye9l1K0To/hWXfgPgvyp6XQNknIYUQieoMH6sp8hJTHbr8vMmD7KPPM
DVDvNbyNgHQ9nvI2p/ycLh4bpNbT97Qa8p0cF0rWoYZCo/5AAuCojezx5e3F1S81
Eryi8dy9co4EApdgMEXjj1/HboADM4iW97vYwB46cw97JEI0DATb1s+RlTFW5wzr
X2kXzmk+od0T5lKSRNwpk8qGEGj4hY1VnfuXldh+pSm2M+1Dc9GJQS6NfMRPtv04
drVHz5NrY+bFGbZUtivA/ui/uInXJa2z69sIctdlRce7VPG+ZKnA1R1GnMi+6R7h
qh8d333wW+jCennsoQG9ayXtMcDHsrIqiukZ+lXe54yJANoJflieRpmeBv4gmRfC
LrJztsYHw0gZxsgfNeKAclH33i/4hcSpaE1AVKXff7MO/Ab+038AJrjGhF0YgWfg
eRl+u75Kef6Npzm3aS6kHL57MqruG2hJlcbgOk60yo3Fdg88bJmPy3XJnMnTkomH
gcuJH3bylHFtGdrT60ORrBoN3/B9U7gC7ygU3lOiSowMQ9qqTu3oS0nHRkvU0kPr
/wuqnKW0QfSe8S0uj8cS
=A1ha
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
