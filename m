Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3LIFNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:13:48 -0500
Received: from top.free-electrons.com ([176.31.233.9]:32827 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751608Ab3LIFNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:13:47 -0500
Message-ID: <52A55187.3050907@free-electrons.com>
Date: Mon, 09 Dec 2013 06:13:43 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: andrew@lunn.ch, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: plat-orion: remove deprecated IRQF_DISABLED
References: <1381549760-5432-1-git-send-email-michael.opdenacker@free-electrons.com> <20131017125414.GB22434@titan.lakedaemon.net>
In-Reply-To: <20131017125414.GB22434@titan.lakedaemon.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On 10/17/2013 02:54 PM, Jason Cooper wrote:
> On Sat, Oct 12, 2013 at 05:49:20AM +0200, Michael Opdenacker wrote:
>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>
>> It's a NOOP since 2.6.35 and it will be removed one day.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> ---
>>  arch/arm/plat-orion/time.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> Applied to mvebu/soc

Oops, I don't see this patch in mainline yet.

It is still in the tree? Did it just miss the last merge window?

Thanks for your support,

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

