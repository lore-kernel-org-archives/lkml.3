Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3DWNvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:51:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45379 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435Ab3DWNvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:51:36 -0400
Date: Tue, 23 Apr 2013 14:51:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        marek.belisko@streamunlimited.com
Subject: Re: [PATCH 2/2] ALSA: ASoc: davinci-mcasp: Add Support BCLK-to-LRCLK
 ratio for TDM modes
Message-ID: <20130423135134.GO5019@opensource.wolfsonmicro.com>
References: <1366378124-14368-1-git-send-email-michal.bachraty@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KM+e2hnYAO+MCJ5e"
Content-Disposition: inline
In-Reply-To: <1366378124-14368-1-git-send-email-michal.bachraty@streamunlimited.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KM+e2hnYAO+MCJ5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 19, 2013 at 03:28:44PM +0200, Michal Bachraty wrote:
> For TDM mode, BCLK-to-LCLK ratio is computed as (tdm_slots) x (word_length).
> I2S mode is only subset of TDM mode with specific tdm_slots = 2 channels.
> Also bclk_lrclk_ratio can be greater than 255, therefore u16 need to be used.

Applied, thanks.

--KM+e2hnYAO+MCJ5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdpHbAAoJELSic+t+oim9Su0P/29cof/BPaMwuwEoE/KQQJco
p7yoUTCI4zgO6DeoGYmpRMLR9rqc6Ugp5WfYVonaCyXZ5fqYF74JcBHTRqzlvGdA
/O207X0WCORvoHGSlppaJCoaQGZxkjza4eZJ1Cj0tyhxVFaCYIGR7Q0RXUxZDWp9
Z0R0jA33E4SRU0+xZM1rhi7Pega5rLgmDAEoNZt11O42Z7lKf+kWk9QksQ7zP9ah
mRjk/H8kzVlgBxd4CjPxDaLTR7ZZT63dpKAHaLJ2X+P1cDzz8TG6J9s2eQvjjdq7
YpWdpJc799DF/rA954sAUx5wFngBIK4vRqCYOxOASeL6D20FaiBkt2EtYacqzSws
xiPajTGoKs92OsEY2XoFNkL3mRLPnpJY7h4HAN7QoURrNFVP+t1iXFjkzOAPrHg1
tjqP1GKczMrM5ZIMlYcNN4GDhBGnklQMTMuOLfCZRp+l71/soLreXwDBFWAwPYIX
iVkDdBnNxdMrRPM/DLXu0P154DNqGjExmNn7XlaWTThrQntv9QHLtx0jIdsVBvms
o93SC00r4NAHTJMDzIRjBbFWE/LMj4dpWCaH6yXM3y4XbsYjOW94Hv7t9XzA5FcT
pD+gIqu7+k8hoydiuRw01Y2GjFW9bUUOAxORaq4c40ILkxlaeCFQnARzR9C2/hOB
W/6hfTwJRt4F1SGr2MNf
=ecXv
-----END PGP SIGNATURE-----

--KM+e2hnYAO+MCJ5e--
