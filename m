Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3JZB13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 21:27:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48901 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3JZB1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 21:27:25 -0400
Date: Sat, 26 Oct 2013 10:27:23 +0900
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 4/5] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
In-reply-to: <1382710529-12082-5-git-send-email-k.debski@samsung.com>
To: "'Kamil Debski'" <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Mateusz Krawczuk'" <mat.krawczuk@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Message-id: <003101ced1ea$85f7e010$91e7a030$%han@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7bit
Thread-index: Ac7RjQQeA+F8IuX1Sui/BMlCS4ypRQAXGYMw
DLP-Filter: Pass
X-AuditID: cbfee68f-b7f836d000001b39-da-526b1a7cb08a
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+ZkW6NVHaQwZs/ghbzj5xjtWi7cpDd
	4vLCS6wWP15fYLO48LSHzeJs0xt2i2k7/7NaXN41h81ixvl9TBaLlrUyW6w9cpfd4mz/bTaL
	w2/aWS3Wz3jN4sDnsXPWXXaPvi2rGD2O39jO5PF5k1wASxSXTUpqTmZZapG+XQJXxt1je9kL
	TrBWvNqyja2B8QBLFyMnh4SAicSBxulsELaYxIV764FsLg4hgWWMEmffTmCFKfq+6BsrRGIR
	o8TfCe1QVb8YJVom97GDVLEJqEl8+XIYzBYR0JT42XCIBaSIWeAHs8SnG6vAdggJ1Ess3P0X
	zOYUcJWY/ewi2AphgUSJIw8/gd3EIqAq8W7PB0YQm1fAVuLq3KOsELagxI/J98BqmAW0JNbv
	PM4EYctLbF7zlrmLkQPoVHWJR391IW4wkni5ewYzRImIxL4X7xhB7pEQmMkhsfR/PzPELgGJ
	b5NBDgXplZXYdIAZ4mNJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLjPWK
	E3OLS/PS9ZLzczcxQqK/fwfj3QPWhxiTgdZPZJYSTc4HJo+8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnvP0wKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAYs7N3h1qKymT2YzvtLeTE3m17U6DR
	wHHxZcIRN+NcG1vRmDd7futmMxSLBf8XfLflySKFHQwv7pkzqyn9PDW32cSf+cT9thVHQm+H
	NxxsVRdKEP2y5cwD7v6520NPmvgpbn57L0PWied+hLFaiz03l8jrCiv3DJUUfcEbcocbp1kG
	lsik+yuxFGckGmoxFxUnAgDc2Z7/FAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsVy+t9jAd0aqewggwn3eSzmHznHatF25SC7
	xeWFl1gtfry+wGZx4WkPm8XZpjfsFtN2/me1uLxrDpvFjPP7mCwWLWtltlh75C67xdn+22wW
	h9+0s1qsn/GaxYHPY+esu+wefVtWMXocv7GdyePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoCuVFMoSc0qBQgGJxcVK+naYJoSGuOla
	wDRG6PqGBMH1GBmggYR1jBl3j+1lLzjBWvFqyza2BsYDLF2MnBwSAiYS3xd9Y4WwxSQu3FvP
	1sXIxSEksIhR4u+EdijnF6NEy+Q+dpAqNgE1iS9fDoPZIgKaEj8bDrGAFDEL/GCW+HRjFRtI
	QkigXmLh7r9gNqeAq8TsZxfBVggLJEocefgJbDWLgKrEuz0fGEFsXgFbiatzj7JC2IISPybf
	A6thFtCSWL/zOBOELS+xec1b5i5GDqBT1SUe/dWFuMFI4uXuGcwQJSIS+168Y5zAKDQLyaRZ
	SCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCU8sz6R2MqxosDjEKcDAq
	8fAWtGcFCbEmlhVX5h5ilOBgVhLhXf0DKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wLSX
	VxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2Mzr1KkQ+nvHVk
	6G3IvdE3MXm9AGf7yS+qqw2ezHu72MzXxTLcUP2vSVhtg93nH+YcnOcCHVcuVwh1jOUt/hk4
	7VKcclS49fzFc0/2RWR28bRUNF1s+BLhN3N9kXxcbuaa1mvxa6OkTu9c7+KX7rxk71rt2fr3
	vi9wWv3ZJq+kayH/2rOc9n+UWIozEg21mIuKEwGmpFQdcQMAAA==
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
 <1382710529-12082-5-git-send-email-k.debski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 25, 2013 11:15 PM, Kamil Debski wrote:
> 
> Change the phy provider used from the old usb phy specific to a new one
> using the generic phy framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/host/ehci-s5p.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)

Hi Kamil Debski,
It looks good. :-)

However, could you re-basing against Greg's 'usb-next' branch?
Now, the file name of 'ehci-s5p.c' is renamed to 'ehci-exynos.c'.
Also, 'Generic PHY Framework' was already merged to Greg's
'usb-next' branch.

Thank you.

Best regards,
Jingoo Han

