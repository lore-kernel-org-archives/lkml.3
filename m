Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab3AaWK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:10:27 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:51715 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab3AaWKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:10:24 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org
Subject: Re: [PATCH] parisc: unbreak automounter support on 64-bit kernel with 32-bit userspace
Date: Thu, 31 Jan 2013 23:10:10 +0100
Message-ID: <1470501.uiZyX6kBKo@donald.sf-tec.de>
User-Agent: KMail/4.9.5 (Linux/3.7.1-17-desktop; KDE/4.9.5; i686; ; )
In-Reply-To: <510AE623.7000609@zytor.com>
References: <20130131200110.GA6032@p100.box> <1359668524.2468.12.camel@dabdike> <510AE623.7000609@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6267936.Gb1GP3pgWl"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart6267936.Gb1GP3pgWl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

H. Peter Anvin wrote:
> On 01/31/2013 01:42 PM, James Bottomley wrote:
> > On Thu, 2013-01-31 at 13:29 -0800, H. Peter Anvin wrote:
> >> On 01/31/2013 12:26 PM, James Bottomley wrote:
> >>> [adding autofs list and maintainer for their perusal and ack, although
> >>> this is an obvious fix to me
> >>> 
> >>> James]
> >> 
> >> The #if list probably should be inverted, and only specific platforms
> >> should have unsigned long...
> > 
> > The whitelist is 64 bit only platforms, like ia64, isn't it?  So yes,
> > they're far less numerous.
> 
> Correct.  It is basically the 64-bit platforms without any 32-bit
> userspace, like Alpha and IA64.

Arm64? Should this be a CONFIG_ARCH_CAN_HAVE_32BIT_USERSPACE that would cover 
this? And may e.g. be used to remove compat_ioctl on those archs, too?

Eike
--nextPart6267936.Gb1GP3pgWl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlEK68kACgkQXKSJPmm5/E6d6ACfQXJciVY9c8+cXb/hw98Spx9d
jh8Anj+sHsqqiRcYfHzgCgV2g7s3DiQ5
=HJ+k
-----END PGP SIGNATURE-----

--nextPart6267936.Gb1GP3pgWl--

