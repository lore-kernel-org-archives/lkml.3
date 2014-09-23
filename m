Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaIWNqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:46:42 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61632 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaIWNql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:46:41 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-55-542179bfb289
Message-id: <542179BD.9070406@samsung.com>
Date: Tue, 23 Sep 2014 15:46:37 +0200
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
MIME-version: 1.0
To: nick <yocto6@gmail.com>, linux@arm.linux.org.uk
Cc: lauraa@codeaurora.org, steve.capper@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, steve.capper@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: FIX Me in pgtable.h
References: <54216FC9.5060605@gmail.com>
In-reply-to: <54216FC9.5060605@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xy7r7KxVDDK4fFbR4/cLQYnvnDHaL
	TY+vsVpc3jWHzeL2ZV6LSW+2MVmsmLeMzeLlxxMsFtMnN7M7cHqsmbeG0aOluYfN43JfL5PH
	zll32T3uXNvD5rF5Sb1H35ZVjB6fN8kFcERx2aSk5mSWpRbp2yVwZbxtfMVW8Jm54sftC0wN
	jJ3MXYycHBICJhJ7rlxggbDFJC7cW8/WxcjFISSwlFHi0dbNzBDOZ0aJnUe/ATkcHLwCWhLL
	5/qANLAIqEpMvXsErJlNwENi2vcesKGiAhESkw7eZgSxeQUEJX5MvgdWIyJgLHHoOMQCZpAF
	F99PZAVJCAsoSHyYcoYRZL6QgIbE/BcyIGFOAU2J+XNWMIHYzAJmEo9a1jFD2PISm9e8ZZ7A
	KDALyYpZSMpmISlbwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkIr7uYFx6zOoQowAH
	oxIPr8cahRAh1sSy4srcQ4wSHMxKIrxiGYohQrwpiZVVqUX58UWlOanFhxiZODilGhiVb5lZ
	f1jvkrBvgtr7igdX53b+MU7vlmxp00xIXDP5QIj03Gmr+648u7tzauaZdZ2LOXwvPrusoM7a
	npn74e17Rh5Xs1VrX6z+vVJZY8qt3t0iyinnz65nebT5084Foe/tOS6+uHlmtUWafOobDY4I
	EzcHy4nqpapP979fuuz2JH7N2Tx7jnmLKLEUZyQaajEXFScCAOqcaFpmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.09.2014 15:04, nick wrote:
> Greetings Arm Maintainers,
> I am wondering about the fix me in pgtable.h for define kern_addr_valid and how to set it to a correct
> value as you state that this needs to be fixed as the defined macro is still 1. This is probably incorrect
> and should be changed.

Dear Nick Krause,

Before you start coding - do you have necessary ARM-based hardware to 
test your changes?

Changing email won't remove LKML archives...

Best regards,
Krzysztof

