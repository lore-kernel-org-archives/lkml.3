Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3LRHyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 02:54:45 -0500
Received: from mailout06.t-online.de ([194.25.134.19]:47197 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3LRHyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 02:54:44 -0500
Message-ID: <52B154BB.8040506@t-online.de>
Date: Wed, 18 Dec 2013 08:54:35 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [BUG: 3.13.0-rc4] inconsistent lock state
References: <52B09446.7060809@t-online.de> <1387306781.19078.288.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1387306781.19078.288.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: SUoXuUZ18hoY+-r4wtoDr-kLiaKwFMe1-5DCGgPpNN7Xaq1dJktANcUmAXUnIO+Zik
X-TOI-MSGID: 45252897-0af0-4b16-9d9c-4595c52bd664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.12.2013 19:59, Eric Dumazet wrote:
> On Tue, 2013-12-17 at 19:13 +0100, Knut Petersen wrote:
>> Hi Linus / everybody!
>>
>> Booting openSuSE 13.1 with kernel 3.13.0-rc4 triggers the attached
>> warning.
>>
>> cu,
>>    Knut
>>
>>
> Following patch should solve the issue.
>
> http://patchwork.ozlabs.org/patch/301382/

Indeed, it solves the problem.

cu,
  Knut

