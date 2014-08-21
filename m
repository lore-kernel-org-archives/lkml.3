Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaHUHiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:38:14 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:45168 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbaHUHiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:38:13 -0400
Message-ID: <53F5A1DB.8070400@iki.fi>
Date: Thu, 21 Aug 2014 10:38:03 +0300
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Milan Broz <gmazyland@gmail.com>
CC: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel crypto API: cryptoperf performance measurement
References: <56334718.JSiBY74glM@myon.chronox.de> <53F2FA10.2000300@iki.fi> <1477690.toHy6ei3xC@myon.chronox.de> <53F4A1E7.8090504@iki.fi> <53F4E571.7030003@gmail.com>
In-Reply-To: <53F4E571.7030003@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 193.67.103.254
X-SA-Exim-Mail-From: jussi.kivilinna@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014-08-20 21:14, Milan Broz wrote:
> On 08/20/2014 03:25 PM, Jussi Kivilinna wrote:
>>> One to four GB per second for XTS? 12 GB per second for AES CBC? Somehow that 
>>> does not sound right.
>>
>> Agreed, those do not look correct... I wonder what happened there. On
>> new run, I got more sane results:
> 
> Which cryptsetup version are you using?
> 
> There was a bug in that test on fast machines (fixed in 1.6.3, I hope :)

I had version 1.6.1 at hand.

> 
> But anyway, it is not intended as rigorous speed test,
> it was intended for comparison of ciphers speed on particular machine.
>

True, but it's nice easy test when compared to parsing results from
tcrypt speed tests.

-Jussi

> Test basically tries to encrypt 1MB block (or multiple of this
> if machine is too fast). All it runs through kernel userspace crypto API
> interface.
> (Real FDE is always slower because it runs over 512bytes blocks.)
> 
> Milan
> 
