Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab3IVKUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:20:37 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54433 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3IVKUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:20:35 -0400
Message-ID: <523EE08C.60309@gmail.com>
Date: Sun, 22 Sep 2013 14:20:28 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/26] ARM: dove: remove custom .init_time hook
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <1379526839-14798-12-git-send-email-sebastian.hesselbarth@gmail.com> <20130921122226.GB31180@lunn.ch>
In-Reply-To: <20130921122226.GB31180@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 02:22 PM, Andrew Lunn wrote:
> On Wed, Sep 18, 2013 at 07:53:44PM +0200, Sebastian Hesselbarth wrote:
>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
>> remove custom .init_time hooks. While at it, also remove some obsolete
>> includes.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   arch/arm/mach-dove/board-dt.c |   11 -----------
>>   1 file changed, 11 deletions(-)
[...]
> Boot tested on cubox.
>
> Tested-by: Andrew Lunn <andrew@lunn.ch>

Thanks Andrew!

Aren't you giving any Acks for dove/kirkwood anymore?

Sebastian
