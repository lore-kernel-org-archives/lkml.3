Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaHYJ3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:29:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45073 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaHYJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:29:12 -0400
X-AuditID: cbfee68d-f79c46d000000b84-09-53fb01e57b45
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, cw00.choi@samsung.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [RESEND PATCH v4 0/2] mfd: arizona: add support for
 INn_MODE register
Date: Mon, 25 Aug 2014 18:25:38 +0900
Message-id: <1408958740-1037-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSqPuU8XewwZNXhhZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLXb9vc9oce7VSkaL+1+PMlpc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPlcu/sHlsWtXJ5nHn2h42j3knAz1e
	TvzN5tG3ZRWjx+dNcgFcUVw2Kak5mWWpRfp2CVwZrzYvZSnYxFax5e0T9gbGRtYuRk4OCQET
	icO7e5kgbDGJC/fWs4HYQgJLGSX+XCmDqfl08Rl7FyMXUHw6o8Sv/mOMEM4cJomLP3awg1Sx
	CWhIfP+8mRnEFgGadHtOJzNIEbNAB7PElG27GEESwgKxEt/WNLCA2CwCqhKX/2wFa+YVcJXY
	+ewgM8Q6bYl9DTPZQJolBG6xS+xaco4RokFA4tvkQ0DNHEAJWYlNB6DqJSUOrrjBMoFRcAEj
	wypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwLg5/e9Z7w7G2wesDzEKcDAq8fCu4PwVLMSa
	WFZcmXuI0RRow0RmKdHkfGB05pXEGxqbGVmYmpgaG5lbmimJ8ypK/QwWEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwFgneyjmxs7j9UwuvyomOd07zVl9/K2YYuUvm4L/TNbvZ8mJSFZpxm36
	4JJxXer8nn38MROCZfdMdVt6fINEw6QLybemHtjPcKLFf7tbd7PqyXtTryT/W7l/WneECO+b
	+P9rQzdKsdlXbJkS8KCtrPKt/ua881On5/75rxG0/+SXPfzLN5b+r9yqxFKckWioxVxUnAgA
	/PoPVJYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jQd2njL+DDXZu0LS4cvEQk8XUh0/Y
	LP5NucFucf3Lc1aL+UfOsVr0v1nIarHr731Gi3OvVjJa3P96lNHi8q45bBZLr19kslj+9j+b
	xYTpa1ksWvceYbc43c3qwO+x4XMTm8eaeWsYPS739TJ5rFz+hc1j06pONo871/awecw7Gejx
	cuJvNo++LasYPT5vkgvgimpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshL
	zE21VXLxCdB1y8wBekNJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPFq
	81KWgk1sFVvePmFvYGxk7WLk5JAQMJH4dPEZO4QtJnHh3nq2LkYuDiGB6YwSv/qPMUI4c5gk
	Lv7YAVbFJqAh8f3zZmYQWwSo4/acTmaQImaBDmaJKdt2MYIkhAViJb6taWABsVkEVCUu/9kK
	1swr4Cqx89lBZoh12hL7GmayTWDkXsDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOC6f
	Se1gXNlgcYhRgINRiYd3JeevYCHWxLLiytxDjBIczEoivBp/gEK8KYmVValF+fFFpTmpxYcY
	TYG2T2SWEk3OB6aMvJJ4Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFIN
	jOf1rsXX7d7zpTXG0qY6YYP9s7S7irLbfSvZlp0UL/E7fODUM1OTFeWPLgiuncAoEXZ8zvln
	b4I/p3y7WKh/wm5y7JOjh/aU5TBVqO5ceoy5SOC+Rs8ZD4fdqe4X1j9P9CxO/qmfs+lRxIr4
	dZLPpNsXL42riL8VMLkkM+O/gPEi1nc/bK24dZVYijMSDbWYi4oTAW2B6PfhAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for INn_MODE register control using platform data.
Each input signal path can be configurated either as a Analogue or Digital using
the INn_MODE registers.

Changes for v4
- Update document content for more clarity

Changes for v3
- Change to use of_property_read_u32_array
- Fix a few typos
- Update commit message

Changes for v2
- Change to support
- Update commit message
- Update document content for more clarity

Inha Song (2):
  mfd: arizona: Add support for INn_Mode register control
  mfd: arizona: Update DT binding to support INn_MODE init_data

 Documentation/devicetree/bindings/mfd/arizona.txt | 7 +++++++
 drivers/mfd/arizona-core.c                        | 8 +++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.0.0.390.gcb682f8

