Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbaHVPBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:01:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303AbaHVPA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:00:58 -0400
Message-ID: <53F75B26.2020101@suse.com>
Date: Fri, 22 Aug 2014 11:00:54 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Autoselecting SPI for MEDIA_SUBDRV_AUTOSELECT?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Antti -

Commit e4462ffc160 ([media] Kconfig: sub-driver auto-select SPI bus)
enables CONFIG_SPI globally for a driver that won't even be enabled in
many cases.

Is there a reason USB_MSI2500 doesn't select SPI instead of
MEDIA_SUBDRV_AUTOSELECT?

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJT91smAAoJEB57S2MheeWytcQP/jVJNWUWQ414XaltxVyAF8XT
kyCCEXl/MslN8W36p6oMC6TX7KaXjQQSFVUltyt/UgcezuqhkU8nBUETEgLVou1n
1uF120zBu3gy3Hr+dG/3Awsdqb1UbrUrNM2LRL6sU5GIqYSdTxErL8inzXjj6/ow
MttC0yBf2aEumihLEfAqcmEPM0ryS9aZECEyclPA+KrYO9qJaicE2lg8JcSrg8yR
TyNYvRrQ2NOuh5thE4qDH/+jfwtZ4yuEXavIgLsZVuDL9+s11RsfOCxY6eLDPPer
qCI3r/2VYm4xMoF06FhOjafKvhhR97H4dm7jecW1zsGfwamrXMmB0+76IJkzxKpA
le7R5NHk9wag2d9zOLmWC2RQbAVspxV5idD/oq+6bSNLl2un89Pz2RMdZGln68db
z+Oz8W7OKhdQm7PyV2RhHNi67rcaGYt5m3fFkjp2RsylqZdQ7oO/zcMOiZxCxdqT
hGmsNXrgRDLoifA71BGrzyC2xmXYDzZ4K89W3msfW/h6TCNu1IWwqxs1qPucaHXk
xBXu5hn5+1sSmgDJAkg5ODum3hCt6PRdP54/D6hy4Ul9742HtBg5MzPEojSlqdLO
yF0ePAs7Ga8/xOGatCsz1aK8upFAOq6fvrakE2ibx5/0+Yyta9efR0X8q3oKskCr
Tc0Azhsxyhe1F/AObQW+
=7Eoh
-----END PGP SIGNATURE-----
