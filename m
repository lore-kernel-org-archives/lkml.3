Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3BUFUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 00:20:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65247 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3BUFUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 00:20:03 -0500
X-AuditID: cbfee690-b7f066d00000169f-19-5125ae82df83
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "'linux-fbdev'" <linux-fbdev@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: 
In-reply-to: 
Subject: [GIT PULL] exynos-dp updates for v3.9
Date: Thu, 21 Feb 2013 14:20:01 +0900
Message-id: <00b901ce0ff3$1967b6a0$4c3723e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OTNvxAwY0KcJpR26zj4Kosnv2NQBpfQSQ
Content-language: ko
x-cr-hashedpuzzle: xNo= Esa6 KkHh Lylr Sw5L aI+m fUd5 ff4K lYH0 0Qsn 2yOV 2122
 3kPC 4xKs 8Kqp
 8Tpz;6;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGYAbABvAHIAaQBhAG4AcwBjAGgAYQBuAGQAaQBuAGEAdABAAGcAbQB4AC4AZABlADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGYAYgBkAGUAdgBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAbwByAHYAYQBsAGQAcwBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA=;Sosha1_v1;7;{805C7E47-CED6-4A09-BAF6-275EFA41DFE6};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 21 Feb 2013 05:19:52
 GMT;WwBHAEkAVAAgAFAAVQBMAEwAXQAgAGUAeAB5AG4AbwBzAC0AZABwACAAdQBwAGQAYQB0AGUAcwAgAGYAbwByACAAdgAzAC4AOQA=
x-cr-puzzleid: {805C7E47-CED6-4A09-BAF6-275EFA41DFE6}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zfd2mdaqBBjOXslmc6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJWTl7FWLCMo+LozNwGxk9sXYycHBICJhJLpi9nhbDF
	JC7cWw8WFxJYxiix7ZAnTM2nOzcYuxi5gOLTGSWe7nnCAuH8YpT49XMhO0gVm4CaxJcvh8Fs
	EaCOBx8XgnUwC7xllPj4aC+QwwHUwS2xujkIpIZTgEdi3Z9OZhBbWEBPYuO5JiYQm0VAVWLB
	18dgcV4BW4nHL+ewQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhlkvISAusSjv7oQJxhJnD/5
	jBWiRERi34t3YOdICPxhlXgxtQ/qY1OJzUf3skDYh9glbu8vg7hBQOLb5EMsEDNlJTYdYIYo
	kZQ4uOIGywRGqVlILpqF5KJZSC6ahWT1AkaWVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxgh
	ETlhB+O9A9aHGJOB1k9klhJNzgdGdF5JvKGxsYmZiamJuaWpuSlpwkrivPKXZAKFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MOr/UFpZ7By2bW3poyfmE08fmPlu84F/W2+prJlxPWPd4n65
	Cbs9513y/H6Ae860x5Nf5WT7z7vDsMN/VrD+R+mzuWqqZw4oLw/t/c39aw+3WsOTgioVizOb
	S+8fynnJxaO6dtkH15+vP63k/ehZLOK2uYR5nWHIBQ3BPo2ob6UHfpUxz5C6vGyhEktxRqKh
	FnNRcSIAXGXWTN4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd2mdaqBBhe+MVqc6PvAanF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzVk5exViwjKPi
	6MzcBsZPbF2MnBwSAiYSn+7cYISwxSQu3FsPFOfiEBKYzijxdM8TFgjnF6PEr58L2UGq2ATU
	JL58OQxmiwB1P/i4kBGkiFngLaPEx0d7gRwOoA5uidXNQSA1nAI8Euv+dDKD2MICehIbzzUx
	gdgsAqoSC74+BovzCthKPH45hwXCFpT4MfkemM0soCWxfudxJghbXmLzmrfMIOMlBNQlHv3V
	hTjBSOL8yWesECUiEvtevAM7R0LgD6vEi6l9rBCfmUpsPrqXZQKjyCwkK2YhWTELyYpZSGYt
	YGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc88+kdjCubLA4xCjAwajEw7vgpUqgEGti
	WXFl7iFGCQ5mJRHenx1AId6UxMqq1KL8+KLSnNTiQ4zJwBCYyCwlmpwPTEd5JfGGxiZmRpZG
	ZhZGJubmpAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoGxxLxt+6c9d/gXiLhuyqxZ8MvJ
	6vsSX6vgbxl/eTnPX1mq6yXcY//vQrr8to3pRh/aT5fv8TZJ1pj+3DdEe6KFRbVKuofe7F2r
	QzJZuVbp8dUVWurvnHKSTWG7zXavvae3MWmVH9L86jaTf12+Yc8ZHdsu9rqVUe6X3Lw0Gmau
	f7Ml6I9VRrsSS3FGoqEWc1FxIgA/vXgRPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Florian, the fbdev maintainer, has been very busy lately, so I send the pull request
for exynos-dp for this merge window.

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

 Linux 3.8 (Mon Feb 18 15:58:34 2013 -0800)

are available in the git repository at:
  git://github.com/jingoo/linux.git tags/exynos-dp-3.9

for you to fetch changes up to bb80934325dab97b479815aed237ebec33ed1c57:

 video: exynos_dp: move disable_irq() to exynos_dp_suspend() (Tue Jan 29 18:26:05 2013 +0900)

----------------------------------------------------------------
exynos-dp updates for the v3.9:

- The missing function calls are fixed.
----------------------------------------------------------------

Ajay Kumar (1):
      video: exynos_dp: move disable_irq() to exynos_dp_suspend()

Jingoo Han (1):
      video: exynos_dp: add missing of_node_put()

drivers/video/exynos/exynos_dp_core.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

--
Best regards,
Jingoo Han

