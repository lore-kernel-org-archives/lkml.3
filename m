Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab3FQNwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:52:50 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:53930 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279Ab3FQNwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:52:49 -0400
Message-ID: <51BF1378.2060707@schinagl.nl>
Date: Mon, 17 Jun 2013 15:47:36 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, Tomasz Figa <tomasz.figa@gmail.com>,
        linux@arm.linux.org.uk, arnd@arndb.de,
        Oliver Schinagl <oliver@schinagl.nl>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, maxime.ripard@free-electrons.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1371251781-17167-1-git-send-email-oliver+list@schinagl.nl> <1894396.Y9rMOhn2P3@amdc1227> <51BF0AD7.1070101@schinagl.nl> <2650626.N0ZZQX0iR6@amdc1227>
In-Reply-To: <2650626.N0ZZQX0iR6@amdc1227>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-06-13 15:23, Tomasz Figa wrote:
> On Monday 17 of June 2013 15:10:47 Oliver Schinagl wrote:
>> On 17-06-13 14:51, Tomasz Figa wrote:
>>> On Monday 17 of June 2013 12:36:47 Oliver Schinagl wrote:
>>>> On 15-06-13 12:28, Tomasz Figa wrote:
<snip>
>> Now we pass this array to add_randomness(array, 16). So add_randomness
>> sees 16 ints in an array. So while there will be a lot of extra zero's,
>> there still be 16 elements copied/processed, no?
>
> The second argument of add_randomness is number of bytes, not number of
> elements in array, as far as I can tell.
Oh wow, very good catch. I had to dig a little into the source where it
said 'nbytes'. I guess the function prototype would have been nicer if it
said nbytes instead of size.

Anyway, with using an array of u8 this is nicely handled.

> Best regards,
> Tomasz
>
oliver
