Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaEZIeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:34:12 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38439 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaEZIeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:34:10 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-7a-5382fc7cfcf1
Message-id: <1401093243.25720.0.camel@AMDC1943>
Subject: Re: [RFT PATCH] regulator: s2mpa01: Use correct register for buck[36]
 ramp delay
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Sangbeom Kim <sbkim73@samsung.com>
Date: Mon, 26 May 2014 10:34:03 +0200
In-reply-to: <CAK9yfHzOcmL30nH1c4iQFfosQ1oWerwQKxkQvX4KxCr4mj+G0Q@mail.gmail.com>
References: <1399456358-12168-1-git-send-email-k.kozlowski@samsung.com>
 <1399461043.22811.3.camel@AMDC1943> <1400854775.7331.6.camel@AMDC1943>
 <CAK9yfHzOcmL30nH1c4iQFfosQ1oWerwQKxkQvX4KxCr4mj+G0Q@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xq7o1f5qCDS7fFLGY+vAJm8W3Kx1M
	Fpd3zWGzOPmnl9Hi4oovTBYLNj5idGDz2DnrLrvHplWdbB53ru1h8+jbsorR4/MmuQDWKC6b
	lNSczLLUIn27BK6MhdOPsRQcZK+4dGMqSwPjc9YuRk4OCQETiQlrNjNC2GISF+6tZwOxhQSW
	Mkos3RLdxcgFZH9mlNjbOoMJJMEroC/R+uwAWIOwQLTE/Z+zmUFsNgFjic3Ll4A1iwhoSbzs
	Xs4E0swssJZRYv7zGUAJDg4WAVWJt8flQWo4BYIlzmw5ygSx4DqjxJKDn8GamQXUJSbNW8QM
	cZGyxLz9x6AWC0r8mHyPBaJGXmLzmrfMExgFZiFpmYWkbBaSsgWMzKsYRVNLkwuKk9JzjfSK
	E3OLS/PS9ZLzczcxQoL76w7GpcesDjEKcDAq8fC+yGsKFmJNLCuuzD3EKMHBrCTC2/wBKMSb
	klhZlVqUH19UmpNafIiRiYNTqoFxl9kktf7LrmYON0xDdlTe1vGq60wKi6iY9rdsW/eLqoM6
	v1+o/T2Yab6L+eTm68/mXSibqjvLMusL606hl0len9+HZLW89tnFWtjp5cg4Z5eohbzI1Wc2
	DN8S/xZPe3vyhlOGZf/sgJ6a5AvPlp7ynBpbM+Wp3/93m6b9V439lSiz+Kn9Tq6DSizFGYmG
	WsxFxYkAJdIIbkwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-05-26 at 13:37 +0530, Sachin Kamat wrote:
> Hi Krzysztof
> 
> Apologies for the delay. I was on vacation during the early part of
> this month and
> got busy with some other stuff later and this mail fell through the cracks.
> 
> 
> On 23 May 2014 19:49, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > Hi Sachin,
> >
> > The s2mpa01 regulator driver uses wrong registers for ramp delay (buck1
> > and buck3 in RAMP1, buck6 in RAMP2) but I am not sure which layout is
> > proper (it seems that that buck1 should be in RAMP2 register).
> >
> > Could you check in S2MPA01 datasheet the registers for ramp delay for
> > buck1, buck3 and buck6?
> 
> I checked the datasheet available with me and according to it
> 
> buck 1 and 6 share the ramp register 0x11 (RAMP2) (bit 4 and 5) and buck 3 uses
> bit 4 and 5 of register 0x10 (RAMP1).

Thanks! I'll send updated version of the patchset.

Best regards,
Krzysztof

