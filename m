Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbbAZFM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:12:57 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49572 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbbAZFMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:12:54 -0500
X-AuditID: cbfee68f-f791c6d000004834-98-54c5ccd0863d
Message-id: <54C5CCD0.7020100@samsung.com>
Date: Mon, 26 Jan 2015 14:12:48 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        =?UTF-8?B?7J207IOB67Cw?= <sangbae90.lee@samsung.com>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] extcon next for 3.20
References: <54C5CBF1.9090104@samsung.com>
In-reply-to: <54C5CBF1.9090104@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkUPfCmaMhBlNfmVg0L17PZjHp/gQW
	i7NNb9gtLu+aw2Zxu3EFm8XxTwdZHNg89s9dw+7Rt2UVo8fnTXIBzFFcNimpOZllqUX6dglc
	GY2/PzMV7OCr6Dl+kL2B8SZ3FyMnh4SAicSzllMsELaYxIV769m6GLk4hASWMko8WHOXCaao
	60UTO4gtJLCIUWLCCwkI+zWjxPeZxl2MHBy8AloSn8+agoRZBFQljk9tYwax2YDC+1/cYAOx
	RQXCJFZOvwK2i1dAUOLH5HtgtoiAhsTLo7dYQPYyC3xilDjxdSZYQlhAR+Li9amMIPOFgAZt
	25MHEuYU0JZ437sJ7DRmAXWJSfMWMUPY8hKb17xlBpkjIbCNXeLAtuUsEAcJSHybfIgFZI6E
	gKzEpgPMEG9JShxccYNlAqPYLCQnzUIydhaSsQsYmVcxiqYWJBcUJ6UXGesVJ+YWl+al6yXn
	525iBEbV6X/P+ncw3j1gfYhRgINRiYe3ofloiBBrYllxZe4hRlOgKyYyS4km5wNjN68k3tDY
	zMjC1MTU2Mjc0kxJnHeh1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxd/6qKnJW2b9j0
	m2mZkK1k8Y+XilPXrNE8qFH5JqVTW5xf9JhQyHLn54evnPyfvX/587+b5/xJ/RP/xGLVnZta
	mw1jr1W9zb8sbng8I+eiVbZzWUjZ4etnC3raLCccYedfd5x7SvFyO76vmpWrzauK9h3xYn8z
	VeNpxcKn1+9cED3d1/n7wlM/JZbijERDLeai4kQAMcX4XqUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAd0LZ46GGDxfr2vRvHg9m8Wk+xNY
	LM42vWG3uLxrDpvF7cYVbBbHPx1kcWDz2D93DbtH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1WUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMGY0/v7MVLCDr6Ln+EH2Bsab3F2MnBwSAiYSXS+a2CFs
	MYkL99azgdhCAosYJSa8kICwXzNKfJ9p3MXIwcEroCXx+awpSJhFQFXi+NQ2ZhCbDSi8/8UN
	sFZRgTCJldOvsIDYvAKCEj8m3wOzRQQ0JF4evQVkc3EwC3xilDjxdSZYQlhAR+Li9amMIPOF
	gAZt25MHEuYU0JZ437uJCcRmFlCXmDRvETOELS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVT
	C5ILipPScw31ihNzi0vz0vWS83M3MYJj9pnUDsaVDRaHGAU4GJV4eBuaj4YIsSaWFVfmHmKU
	4GBWEuEtnwIU4k1JrKxKLcqPLyrNSS0+xGgKDIGJzFKiyfnAdJJXEm9obGJmZGlkbmhhZGyu
	JM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cBYuvv3mQVPHhs6VL247bp+j9gaVktdlTNXdx04
	ZP9lTXn+trwSU0ZduaM9U9rMds1jdbpb//U9i8vLVreOk2dyHiddvqvGNelAX4Ftme6qIzK3
	G1XfyJ/XeZC3Q/7+1qMcSXe8vifc8d1rZBWRIRrJMX2Db0D5ro7rhk9FeI8xXj2oXXpTWnqe
	EktxRqKhFnNRcSIABuH39O8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

I'm so sorry about missing 'linux-kerenl mailing list' address.
I add 'linux-kernel mailing list' again.

Best Regards,
Chanwoo Choi

On 01/26/2015 02:09 PM, Chanwoo Choi wrote:
> Dear Greg,
> 
> This is extcon-next full request for v3.20. I add detailed description of this
> pull request on below. Please pull extcon with following updates.
> 
> This pull-request is based on Linux 3.19-rc5 (char-misc-next branch).
> 
> Best Regards,
> Chanwoo Choi
> 
> The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:
> 
>   Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-for-3.20
> 
> for you to fetch changes up to 6594890020d505ddfab24a2dcd0b68b84628ed1e:
> 
>   extcon: max77693: Constify struct regmap_config (2015-01-26 13:47:55 +0900)
> 
> ----------------------------------------------------------------
> Update extcon for v3.20
> 
> This patchset fix minor issue of extcon driver.
> 
> Detailed description for patchset:
> - Remove duplicate header file in extcon-class.c and add 'const' keyword for
>   array in extcon-max77693.c.
> - Release iio channel when executing *_remove() function in extcon-adc-jack.c
> 
> ----------------------------------------------------------------
> Ivan T. Ivanov (1):
>       extcon: adc-jack: Release IIO channel on driver remove
> 
> Krzysztof Kozlowski (1):
>       extcon: max77693: Constify struct regmap_config
> 
> Wei Yongjun (1):
>       extcon: Remove duplicated include from extcon-class.c
> 
>  drivers/extcon/extcon-adc-jack.c | 1 +
>  drivers/extcon/extcon-class.c    | 1 -
>  drivers/extcon/extcon-max77693.c | 2 +-
>  3 files changed, 2 insertions(+), 2 deletions(-)
> 

