Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaHROfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:35:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46849 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaHROfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:35:47 -0400
Date: Mon, 18 Aug 2014 09:09:25 -0500
From: Mark Brown <broonie@kernel.org>
To: Sean Cross <xobs@kosagi.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140818140925.GX14537@sirena.org.uk>
References: <20140818083055.7cedc567@canb.auug.org.au>
 <53F1A263.3030000@kosagi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V2AZ19bMCakBLong"
Content-Disposition: inline
In-Reply-To: <53F1A263.3030000@kosagi.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 166.147.100.74
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V2AZ19bMCakBLong
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2014 at 02:51:15PM +0800, Sean Cross wrote:

> That gives it almost the exact same kernel config as the SGTL5000.

> Is this the sort of thing you can apply on your end, or would you like
> me to resubmit a v12 with just this file?  I'm afraid I don't have a PPC
> toolchain to test with.

Please submit your fix using the normal submission process.

--V2AZ19bMCakBLong
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8gkRAAoJELSic+t+oim9JfUP/1NOTCij+JLTF9XUEJ5/ECNu
kWOUC65HC6fgDVv3nCJUsmKQgrZPqOhM+2c63UuSM7x2esnhWnWoYVrxaA78zYDf
NpCnw3q1Y0v3CNfLxHSZpurpQqCwahXPwX91i9BJFLth+zoLfKSCpsSShp7IteTs
5O7Zrwh3jX+I4lPTLrBXVbRNIPTO2gFhwCMT8KsR0+KNHYu1OpC691cl2/2SvE1z
5AvqBbhYLS9WpziLuJVmUZRsnhVioZtfSBYzMoggRUiFjk0jclNg+ccs53rndoth
+YNPrej4udz+kBjffVOmmczGct/DidX9TpiOjITNDErNvR4c7sjZ7/6m4DRmQL86
4VKhWnhPbF1uzfwRoFY0Na9vZhii3tWWx6Qd0wsHRifxysuO19aS+OZ1uovBh/QA
TioW2GibEFCysU8UB02YPTTnVa0d9NsLhhGSqznieFij4Gopeud94ZmtVR7sk7Ll
I4r8fTDhOrxhZtjbjjDf+Ga6K1Lq8BIkMYFewVlVQx2+18R5Gl/nKpzxi1ClC4Qh
vaLpYTfkRrsckTAg10j/34r9VpwDCYsgQTvn00mAg5djxpYPibqKMHQTRpb6MxIe
5YjumyijkNPyETDf+IvnYODR69sFVJGZj2KHDGQIbV+YcT2mTonpXVi/xL3mXNHe
0b+9Dbx2y1Xtcy0ma3aH
=GzW9
-----END PGP SIGNATURE-----

--V2AZ19bMCakBLong--
