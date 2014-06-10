Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaFJNts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:49:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55345 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751335AbaFJNtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:49:46 -0400
Message-ID: <53970CF5.50701@free-electrons.com>
Date: Tue, 10 Jun 2014 15:49:41 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Carpenter <paul@pcserviceselectronics.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [RESEND2 PATCH v4 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire
 Interface) controller support
References: <1401785392-26602-1-git-send-email-boris.brezillon@free-electrons.com> <1401785392-26602-3-git-send-email-boris.brezillon@free-electrons.com> <20140610083850.GB2620@katana> <5396C848.8020701@pcserviceselectronics.co.uk>
In-Reply-To: <5396C848.8020701@pcserviceselectronics.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

On 10/06/2014 10:56, Paul Carpenter wrote:
> Wolfram Sang wrote:
>> On Tue, Jun 03, 2014 at 10:49:52AM +0200, Boris BREZILLON wrote:
>>> The P2WI looks like an SMBus controller which only supports byte data
>>> transfers. But, it differs from standard SMBus protocol on several
>>> aspects:
>>> - it supports only one slave device, and thus drop the address field
>>> - it adds a parity bit every 8bits of data
>>> - only one read access is required to read a byte (instead of a read
>>>   followed by a write access in standard SMBus protocol)
>
> Minor quibble should be
> "(instead of a write followed by a read access in standard SMBus
>   protocol)"
>

Fixed.

Thanks for pointing this out.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

