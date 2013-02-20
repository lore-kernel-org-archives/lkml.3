Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3BTFCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:02:43 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:44463 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3BTFCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:02:41 -0500
Message-ID: <512458E3.8050402@synopsys.com>
Date: Wed, 20 Feb 2013 10:32:27 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "linux-next@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: ARC Port's linux-next URL update
References: <5123C036.2020202@synopsys.com> <20130220102147.dc301eef8d32f0a88d066794@canb.auug.org.au>
In-Reply-To: <20130220102147.dc301eef8d32f0a88d066794@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Stephen,

On Wednesday 20 February 2013 04:51 AM, Stephen Rothwell wrote:
> Hi Vineet,
>
> On Tue, 19 Feb 2013 23:41:02 +0530 Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>
>> Can you please point ARC's next tree to following:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git for-next
>
> Done.

Thanks !.

>
>> This is an exact copy of what I had in github (based off 3.8-rc5)
>
> Not just a copy, but you did the right thing and it is the same commits.
> Thanks.

Yeah, that was the idea so that a worst case github branch's (signed tag )pull
request matched what I had here.

>
>> I suppose a week's worth of cooking should be enough to send a pull request to
Linus.
>
> Well, you have not rebased it so just moving sites should not affect
> you. However, even what is there has only been in -next for 2 days, so
> maybe a couple of days wait wouldn't hurt.

Cool !

Thx,
- -Vineet
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRJFjVAAoJEGnX8d3iisJeBp8P/048F3PjD1EsX6jrhLbsCwvP
ng9xjd1WN0CrKFziVg7yIedo1DNUg5+Hb6rkkFLy+3YiKp8RJu0tN7bi9QbOxCM6
sMky3HmGRPrfAkNcQZJOKEI+wm4DEikwPSy1C437fR8STBjmdV1Z1YAlni8Nf4XK
ZQiPCFh2ytOZQXD9jqU7rKyADDvcQGtcznv9PqcX66WuNgvlIyrOsLK/TrjY9f5G
p/pLM2f4/WyANYrkMRqDeEPF+44jbMYLeQsNs9VfccfWxAFSh4ObfZINqCHPcubU
XB3yv1+T61yewIw9q2NHh3UK5yhwuAvwdZHJdYNqRvK1YhRib54UUOXaJEBLISzv
Sqv3lQ1wTTRku93pI6ut6rj24RcwEMza3SMY9lhekXEpGVEgqcgdbJoX2GUlBWlE
rQDEeYoaVwEJ0xFjOiAw62JAaIdkWD1ko/rljWjQK3R7NHTYsNxvOcsyRYs5bjk8
hQaaaK/zPcTWW3HjSYJa43kL5dC2q3GFDA+SB7up6hkTNzOXXjdi/sYkzvOvxh85
Ln/RXhFPc3jLzNwbDH++uilNvBHTE98aI5wcHDXQ/PNxT7ZnbZHfMowmLcbm8kAP
mP00s2NA245ayJ5UsqeFvb+YjoB9qtIiPJNAKwPLX21jeAgjMz1Wi1HDbJ0jBkID
8CIpvoeoDA3/eEYlZVek
=cfos
-----END PGP SIGNATURE-----

