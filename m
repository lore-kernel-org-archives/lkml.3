Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3KQQAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:00:51 -0500
Received: from server19320154104.serverpool.info ([193.201.54.104]:37979 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab3KQQAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:00:46 -0500
Message-ID: <5288E826.7050204@hauke-m.de>
Date: Sun, 17 Nov 2013 17:00:38 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lgirdwood@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: build error with CONFIG_REGMAP=m and CONFIG_REGULATOR=y
References: <5288DB85.8060105@hauke-m.de> <20131117152721.GA20266@sirena.org.uk>
In-Reply-To: <20131117152721.GA20266@sirena.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/17/2013 04:27 PM, Mark Brown wrote:
> On Sun, Nov 17, 2013 at 04:06:45PM +0100, Hauke Mehrtens wrote:
> 
>> In OpenWrt we are seeing some build errors when CONFIG_REGMAP=m
>> and CONFIG_REGULATOR=y are set.
> 
> REGMAP is a bool config option, it should not be possible to set it
> to m. How have you managed to do that?
> 
Sorry, I you are right, I just saw we have a patch applied on top of
the mainline kernel which makes it possible to build REGMAP as module.

Hauke
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSiOgfAAoJEIZ0px9YPRMygR4P/inb+qZKSSA7qloN2ipKasbC
mDKV/LivY6l3Je+rWTRCESkGOw0jO09rO1AizCoUN47u6yYuC6/IGIPioDXTciFf
iDl46Lhfirv3rlWyrQTC6ZAAxcQUzFJNgXD0hb+ehw3MBC9okB5NQgq9QATtpW9L
Bbu7vCgqG7bxCXXq0DW/ygPMR5axKWQwbQdDCfz+06wYqWQqj2okWtHvhXCe7Skb
ROZ8FvOcnXKKjoGOEJRtbcfUt44dIM8RGJtKj5vjXtnSm+eJQhL1OzqUxOY7OODW
Fxqs97N7rrsPVwXNRYSrHjtmul3feLUaxALXQiSskjS8zJsJBgR9jGJjMp2auN5B
4ffxa0+thFsSNSXQd2bfDPnZzZKZf2EWr3h0BqWZPjN60pIji/WUXMSecVd+9zNH
axONP2lKOp0hPxsSi0hvLUGHAyAsOTzShPKjV+vIosb9aFn5/3GeQqOrY6abmF/1
HPoIds00q2B9VVV83PQeLvMFhjcW++1HDhP7QJ+QiUByN9I96M1Awd27ypsf5PT/
fKqIgumJk2Jy3rKmpOwMHlpONBhD39qW3tb9lmiXeWgAdvaSH/kuR5Lwsbe3vhvg
p+hTwmubGTwFHaIKUD7APJk7daYUwR8VEP3fbwsYc3bCGMtN61FNyl5HymYteJMg
0g4dQrXMaPTZJcMTp4nz
=LoHr
-----END PGP SIGNATURE-----
