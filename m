Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbaIRTdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:33:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38026 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaIRTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:33:06 -0400
Message-ID: <541B336D.3030506@gmail.com>
Date: Thu, 18 Sep 2014 21:33:01 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>	 <1404496099-26708-19-git-send-email-t.figa@samsung.com>	 <1405505756.4408.24.camel@x220> <53C676DB.6070002@samsung.com>	 <1409825817.5546.99.camel@x220> <1411068565.2017.83.camel@x220>
In-Reply-To: <1411068565.2017.83.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.09.2014 21:29, Paul Bolle wrote:
> On Thu, 2014-09-04 at 12:16 +0200, Paul Bolle wrote:
>> On Wed, 2014-07-16 at 14:58 +0200, Tomasz Figa wrote:
>>> I had two patches fixing those, but apparently this was lost in action.
>>> The correct solution is s/PLAT_S5P/ARCH_S5PV210/. I will include this in
>>> a follow-up series if nobody objects.
>>
>> No one objected, as far as I know.
>>
>> Exactly the same references are still to be found in v3.17-rc3 and
>> next-20140903. Perhaps someone actually familiar with this matter (ie,
>> not me) could submit one or more patches that implement Tomasz'
>> proposal.
> 
> We're now at v3.17-rc5 and next-20140918 and nothing has changed. I
> raised this issue the day it hit linux-next. After two months it's still
> not fixed. Could anyone familiar with ARCH_S5PV210 please jump in?

Basically, it turned out that no respin was necessary and I didn't post
those two patches. Now, I don't work for Samsung anymore, but let me see
if I can find them in my private tree and then some time to send them.

Best regards,
Tomasz
