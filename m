Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997AbaGPOoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:44:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48057 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933848AbaGPOof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:44:35 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-b2-53c68fd0939f
Message-id: <53C68FAB.9070102@samsung.com>
Date: Wed, 16 Jul 2014 16:43:55 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 04/19] serial: samsung: Remove support for legacy clock code
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <1404496099-26708-5-git-send-email-t.figa@samsung.com>
 <1405502840.4408.2.camel@x220> <53C67386.5070401@samsung.com>
 <1405520767.4408.39.camel@x220> <1405521324.4408.44.camel@x220>
In-reply-to: <1405521324.4408.44.camel@x220>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xq7oX+o8FG7xqN7L4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i0a0zzBardv1hdOD2+P1r
	EqPHzll32T02repk89i8pN7jyokmVo++LasYPbZfm8fssXH7EyaPz5vkAjijuGxSUnMyy1KL
	9O0SuDIefjnEVrCZrWL36+usDYwTWLsYOTkkBEwkDv7axgJhi0lcuLeerYuRi0NIYCmjxOTb
	D5khnM+MEl3rGxhBqngFtCQmHlrFDGKzCKhKTGn6D9bNJqAm8bnhERuIzQ9Us6bpOlCcg0NU
	IELi8QUhiFZBiR+T74GViwgoS7RuvscOMp9Z4B+TRNOy3WAXCQsESLx9MRtq8V9GiZVzfoAN
	5RTQkVj/9hjYEcwC6hKT5i1ihrDlJTavecs8gVFwFpIls5CUzUJStoCReRWjaGppckFxUnqu
	oV5xYm5xaV66XnJ+7iZGSDx92cG4+JjVIUYBDkYlHl6G2UeDhVgTy4orcw8xSnAwK4nwPmg/
	FizEm5JYWZValB9fVJqTWnyIkYmDU6qBsdp2vtS9KAELkU6H3vs/Ox6cqlbb6n6gsPpvUNrW
	pv6v7IluT9Re/9XS+sVxZ5NVdNfdLO8Vybdm+decnPqzxuK+aEbS1Qc2BSs2P2mcqMzGo3Js
	Woa02qOgddJqbWaS2xY9bbt/VHbp5nanjvcvI+cmv+Nh0j/K+uqB9NlIruZFj/5/ud7DrsRS
	nJFoqMVcVJwIAMbtQiuFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.07.2014 16:35, Paul Bolle wrote:
> On Wed, 2014-07-16 at 16:26 +0200, Paul Bolle wrote:
>> On Wed, 2014-07-16 at 14:43 +0200, Tomasz Figa wrote:
>>> That's right. Apparently I missed them. I guess that's not critical,
>>> though, and could be done in separate patch, right?
>>
>> This is not critical at all, so that's fine with me. 
> 
> Actually, that's only correct if the solution here is to just remove the
> (currently) dead code hidden behind CONFIG_SAMSUNG_CLOCK. But if the
> solution requires something less trivial, that might be quite wrong.
> 
> So please disregard my comment!

The code between those ifdefs is no longer used, because all Samsung
platforms use the Common Clock Framework after this series. So I believe
we can safely remove this dead code.

Best regards,
Tomasz
