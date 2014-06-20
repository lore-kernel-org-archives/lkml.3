Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaFTBNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 21:13:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63877 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaFTBNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 21:13:23 -0400
X-AuditID: cbfee68f-b7fef6d000003970-0f-53a38ab07b56
Message-id: <53A38AB0.3010606@samsung.com>
Date: Fri, 20 Jun 2014 10:13:20 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Charles Keepax'" <ckeepax@opensource.wolfsonmicro.com>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Subject: Re: [PATCH] extcon: Remove unnecessary OOM messages
References: <000401cf8ab6$6613d350$323b79f0$%han@samsung.com>
In-reply-to: <000401cf8ab6$6613d350$323b79f0$%han@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWyRsSkRHdD1+Jgg4+bDSz+TbnBbnF54SVW
	i9cvDC0u75rDZnG7cQWbA6vHy4m/2Tz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr49efLqaC
	bywVx15vYmpg/MbcxcjJISFgInHm8RImCFtM4sK99WwgtpDAUkaJL23cMDUbHy9k6WLkAopP
	Z5SYs2EWE4TzmlFi8aLZYN28AloSWz9+YwWxWQRUJf7smskIYrMBxfe/uAE2VVQgTGLl9Css
	EPWCEj8m3wOzRQRUJD6vP84GMpRZYAejxK5J98EGCQvYSGz5doId4iRbif/b5oAN5RSwk7i8
	cheYzSygI7G/dRobhC0vsXnNW2aQQRIC29gl3iz6A3WRgMS3yYeAtnEAJWQlNh2Ael9S4uCK
	GywTGMVmIblpFpKxs5CMXcDIvIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjMJ5O/3vWv4Px
	7gHrQ4zJQCsnMkuJJucD4zGvJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTAuiZ1q9+vwbw7Vly7ph0vWLmoSkF6TumLt9Y2ZMV7PuFee6m7J1Jh1
	1WC9DfsD64yYhK2N+iblwa0ln9OyKo+6xK/ePZ3x646AC6JTFbZUeeT+yxD5aFXR8+xLe0ni
	FCaZpX3C/udzpv2ceGwCU3Zcn35XgNmmxvX3xffl5XHK9F70Z6l6mKbEUpyRaKjFXFScCABj
	7iO7vQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoO6GrsXBBj2/NCz+TbnBbnF54SVW
	i9cvDC0u75rDZnG7cQWbA6vHy4m/2Tz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCGMePXny6mgm8sFcdeb2JqYPzG3MXIySEhYCKx8fFCFghbTOLCvfVs
	XYxcHEIC0xkl5myYxQThvGaUWLxoNhNIFa+AlsTWj99YQWwWAVWJP7tmMoLYbEDx/S9usIHY
	ogJhEiunX2GBqBeU+DH5HpgtIqAi8Xn9cbANzAI7GCV2TboPNkhYwEZiy7cT7CC2kICtxP9t
	c8CGcgrYSVxeuQvMZhbQkdjfOo0NwpaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqQXJBcVJ
	6blGesWJucWleel6yfm5mxjB8fpMegfjqgaLQ4wCHIxKPLwdpouDhVgTy4orcw8xSnAwK4nw
	nm4HCvGmJFZWpRblxxeV5qQWH2JMBgbBRGYp0eR8YCrJK4k3NDYxM7I0Mje0MDI2J01YSZz3
	YKt1oJBAemJJanZqakFqEcwWJg5OqQZG1uWnCmdJHddleXgyZNehFvm3fcvsS6//Orrw763F
	5vJq+6LN1qS99VoeoyPaE/PHS15z34HrhzZ8j1smqGpVFzH73Kctn7evaBb6vFDz18E5gvnT
	Soy57m6ZFZBtnyGpdnjKoUSPSbt2Rx+ZtvW6yCeDC/vt1h5tyDJiW/+su3zVx8YvG/h7Dimx
	FGckGmoxFxUnAgBQjOgwGwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 02:30 PM, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message. The following
> checkpatch warning is also removed.
> 
>   WARNING: Possible unnecessary 'out of memory' message
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/extcon/extcon-arizona.c  |    4 +---
>  drivers/extcon/extcon-max14577.c |    5 ++---
>  drivers/extcon/extcon-max77693.c |    5 ++---
>  drivers/extcon/extcon-max8997.c  |    4 +---
>  4 files changed, 6 insertions(+), 12 deletions(-)

Applied it.

Thanks,
Chanwoo Choi

