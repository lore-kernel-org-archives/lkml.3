Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaDULbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:31:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39539 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaDULbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:31:20 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-b4-5355018729d4
Message-id: <5355018D.9050402@samsung.com>
Date: Mon, 21 Apr 2014 20:31:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCHv4 0/8] Resource-managed extcon device register function
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
In-reply-to: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkULedMTTY4MATCYvXLwwtLu+aw2Zx
	u3EFm8WCPSUWMya/ZHNg9ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6MfXvOMhf0CVa8OdTP
	3sB4l7eLkZNDQsBEYvrdPmYIW0ziwr31bF2MXBxCAksZJbZu2swGU/Tp1TmoxHRGiaMPdjJD
	OK8ZJRqPH2MEqeIV0JI4f6EbrINFQFXi9r0/TCA2G1B8/4sbYHFRgTCJldOvsEDUC0r8mHwP
	zBYR0Ja4P+EzC8hQZoEljBJzj30CSwgLeEt8Ob8AbIGQgIfE6U/zwW7lFPCUWDR1IVicWUBH
	Yn/rNDYIW15i85q3YNdJCCxjlzh7ai0LxEUCEt8mHwKyOYASshKbDkD9LClxcMUNlgmMYrOQ
	3DQLydhZSMYuYGRexSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iREYRaf/PevdwXj7gPUhxmSg
	lROZpUST84FRmFcSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjGq/lJ/zR/XfY5VOKjrb2rzp9MyjPDu4E9fYxG897dZk+69gthhb/6vYK+76x3XU
	tz85fjLly5yLn4zMUx+lzS3ikbHd8uPeic0HmH+aCAV6KO7bNimdU3fR15usocrO3ioLHQID
	bI5MDVrM327GOftdZY3azeINm3Mn3s3Y6KLzt+K2yVzxbCWW4oxEQy3mouJEAG3pZ764AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoG47Y2iwwb1/AhavXxhaXN41h83i
	duMKNosFe0osZkx+yebA6tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGm
	ZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAy5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYE
	wfUYGaCBhDWMGfv2nGUu6BOseHOon72B8S5vFyMnh4SAicSnV+fYIGwxiQv31gPZXBxCAtMZ
	JY4+2MkM4bxmlGg8fowRpIpXQEvi/IVusA4WAVWJ2/f+MIHYbEDx/S9ugMVFBcIkVk6/wgJR
	LyjxY/I9MFtEQFvi/oTPLCBDmQWWMErMPfYJLCEs4C3x5fwCsAVCAh4Spz/NZwaxOQU8JRZN
	XQgWZxbQkdjfOo0NwpaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWl
	eel6yfm5mxjBMfpMagfjygaLQ4wCHIxKPLwzSkKChVgTy4orcw8xSnAwK4nwRqwHCvGmJFZW
	pRblxxeV5qQWH2JMBgbBRGYp0eR8YPrIK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1oJBAemJJ
	anZqakFqEcwWJg5OqQZG+/n9Z2/1yNWwK7GYXZXfd6em+bDJ8/sqvadl1ijfVX7e8PGgdOMf
	u4cRa47dEv1whGe1dOG5qYyfrhx9kBTovynT53bohVuTZbd/OnjwzD4x76w/HUe5YpoCzu7w
	PRJj2fnt3TvmyQvcXF9nnXih/KsjeWKVhH7ohUuTZpQc+yW+J9W+7LvgUiWW4oxEQy3mouJE
	AAxUNUgVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangjung,

On 04/21/2014 07:10 PM, Sangjung Woo wrote:
> These patches add resource-managed extcon device register functions for
> developers' convenience and apply them to related device driver files.
> This work can make the code more tidy since extcon device is automatically
> unregistered on driver detach so tiresome managing codes could be removed.
> 
> 
> Changelog
> 
> v4:
> * fix the memory leak bug becuase of single pointer
> * clean up the unnecessary code and make proper indentation
> 
> v3:
> * send the right version instead of previous v1
> * add the credit for reviewers according to the review rules
> 
> v2:
> * modify and clean up all unnecessary code reported by Chanwoo
> * fix the bug reported by Seung-Woo
> * add the credit for reviewers
> 
> v1:
> * initial version
> 
> Sangjung Woo (8):
>   extcon: Add resource-managed extcon register function
>   extcon: adc-jack: Use devm_extcon_dev_register()
>   extcon: gpio: Use devm_extcon_dev_register()
>   extcon: max14577: Use devm_extcon_dev_register()
>   extcon: max77693: Use devm_extcon_dev_register()
>   extcon: max8997: Use devm_extcon_dev_register()
>   extcon: palmas: Use devm_extcon_dev_register()
>   extcon: arizona: Use devm_extcon_dev_register()
> 
>  drivers/extcon/extcon-adc-jack.c |   30 ++++++------------
>  drivers/extcon/extcon-arizona.c  |   12 +++----
>  drivers/extcon/extcon-class.c    |   64 ++++++++++++++++++++++++++++++++++++++
>  drivers/extcon/extcon-gpio.c     |   16 +++-------
>  drivers/extcon/extcon-max14577.c |    9 ++----
>  drivers/extcon/extcon-max77693.c |    7 ++---
>  drivers/extcon/extcon-max8997.c  |    4 +--
>  drivers/extcon/extcon-palmas.c   |   15 +++------
>  include/linux/extcon.h           |   17 ++++++++++
>  9 files changed, 108 insertions(+), 66 deletions(-)
> 

Applied this patchset.

But, applied below patch [1] instead of patch[2] on v4.

[1]
[PATCHv5] extcon: Add resource-managed extcon register function
- https://lkml.org/lkml/2014/4/21/140

[2] 
[PATCHv4 1/8] extcon: Add resource-managed extcon register function
- https://lkml.org/lkml/2014/4/21/128

Thanks,
Chanwoo Choi
