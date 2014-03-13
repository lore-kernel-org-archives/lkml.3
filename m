Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaCMKZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:25:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42080 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaCMKZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:25:13 -0400
X-AuditID: cbfee68e-b7f566d000002344-09-53218786ed3a
Message-id: <53218786.7010208@samsung.com>
Date: Thu, 13 Mar 2014 19:25:10 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v3 0/4] mfd: max8997: add regmap support
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsWyRsSkQLe9XTHY4PxORoslF6+yW0x9+ITN
	4ujOiUwWk568Z7Y4vOgFo8XElZOZLV6/MLS4//Uoo8W3Kx1MFjc/fWO1uLxrDpvF1jfrGC3W
	HrnLbnG7cQWbxbW9x5ktHhzeyW6xe9dTVov9nR2MFqe7WR2EPXbOusvusWfiSTaPzSu0PDat
	6mTzuHNtD5vHvJOBHnvm/2D16NuyitFj+ryfTB6fN8l5rN+ylSmAO4rLJiU1J7MstUjfLoEr
	o/HrG+aCTwIV0ze/Z21g/M7TxcjBISFgInHtsX4XIyeQKSZx4d56ti5GLg4hgaWMEmda/7NA
	JEwknixZwAyRmM4ocWj1WiYI5xWjxJKb19hBqngFtCQ2bFvFBGKzCKhK/L41mRnEZgOK739x
	gw3EFhUIk1g5/QoLRL2gxI/J98BsEaCaOx/ng81hFjjKLPG+QQ7EFhawkVjUupQZ5FIhAWeJ
	t8fByjkFXCQapq+AKteR2N86jQ3ClpfYvOYt2KESAmc4JLY/3McKcY+AxLfJh1ggPpaV2HSA
	GeIxSYmDK26wTGAUm4XkollIxs5CMnYBI/MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMAE
	cfrfs74djDcPWB9iTAZaOZFZSjQ5H5hg8kriDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY7/gtX3u36dcCfHV3mdxTvvJpfNq2w784lg1/2N9lpWA
	+pP989nnSC26L7R8ddPJM532c//+kTnl/T21Z+7imIjUa7fEJ67m2ns/5I/KQ015Hw3diSFW
	u9geadQsdVsyf2HfMqtM/XQDl7l3GS+WKpTe3maYp8etuUv7gqrZaZYrXO6ic2zKNJRYijMS
	DbWYi4oTAbWfG60mAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsVy+t9jQd22dsVgg7YeE4slF6+yW0x9+ITN
	4ujOiUwWk568Z7Y4vOgFo8XElZOZLV6/MLS4//Uoo8W3Kx1MFjc/fWO1uLxrDpvF1jfrGC3W
	HrnLbnG7cQWbxbW9x5ktHhzeyW6xe9dTVov9nR2MFqe7WR2EPXbOusvusWfiSTaPzSu0PDat
	6mTzuHNtD5vHvJOBHnvm/2D16NuyitFj+ryfTB6fN8l5rN+ylSmAO6qB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6DslhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY0bj1zfMBZ8EKqZvfs/awPidp4uRk0NCwETiyZIFzBC2
	mMSFe+vZuhi5OIQEpjNKHFq9lgnCecUoseTmNXaQKl4BLYkN21YxgdgsAqoSv29NButmA4rv
	f3GDDcQWFQiTWDn9CgtEvaDEj8n3wGwRoJo7H+eDzWEWOMos8b5BDsQWFrCRWNS6FGgOB9Ay
	Z4m3x8HKOQVcJBqmr4Aq15HY3zqNDcKWl9i85i3zBEaBWUg2zEJSNgtJ2QJG5lWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwQnomfQOxlUNFocYBTgYlXh4VyxXCBZiTSwrrsw9xCjBwawk
	wsvarBgsxJuSWFmVWpQfX1Sak1p8iDEZGAATmaVEk/OByTGvJN7Q2MTMyNLI3NDCyNicNGEl
	cd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgdNvvdlzshNd2kxskz2M34nkvLlPA07f5N/KaX
	uXeJzu/Ok34VkKja2RcXGNw7i8FdwpzxYuEHJ9W75ze/Om7/je3TW1Y/iWsbzjywC7eNbzr8
	Zc5lzxOle0sWzi5/bbOi/otTyBHZvyZ6/i0h//m4J4g5ph46ejrnVcY7gao5bYcLonM1zimx
	FGckGmoxFxUnAgBWdio2hAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On 03/13/2014 06:38 PM, Robert Baldyga wrote:
> Hi,
> 
> This patchset modifies max8997 driver and associated function drivers to use
> register maps instead of operating directly on i2c bus. This change allowed
> to simplify irq handling, and to move some initializations to individual
> function drivers. Hence now when some functions are not enabled, their i2c
> clients, regmaps and irqs are not registered.
> 
> Best regards
> Robert Baldyga
> Samsung R&D Institute Poland
> 
> Changelog:
> 
> v3:
> - fix error handling
> - fix deinitializations order
> - move muic irq enum values renaming to separate patch
> 
> v2: https://lkml.org/lkml/2014/3/12/237
> - rebase patches on Lee Jones' MFD tree
> - add missing selects in Kconfig
> - add missing deinitializations
> - add interrupt disabling when suspend
> - few minor changes and typo fixes
> 
> v1: https://lkml.org/lkml/2014/3/11/291
> 
> Robert Baldyga (4):
>   mfd: max8997: use regmap to access registers
>   mfd: max8997: handle IRQs using regmap
>   mfd: max8997: change irq names to upper case
>   mfd: max8997: move regmap handling to function drivers
> 
>  drivers/extcon/extcon-max8997.c     |  181 +++++++++++++---
>  drivers/input/misc/max8997_haptic.c |  121 +++++++++--
>  drivers/leds/leds-max8997.c         |   13 +-
>  drivers/mfd/Kconfig                 |    3 +-
>  drivers/mfd/Makefile                |    2 +-
>  drivers/mfd/max8997-irq.c           |  387 -----------------------------------
>  drivers/mfd/max8997.c               |  236 +++++++--------------
>  drivers/power/max8997_charger.c     |   33 +--
>  drivers/regulator/max8997.c         |   87 ++++----
>  drivers/rtc/rtc-max8997.c           |  102 ++++++---
>  include/linux/mfd/max8997-private.h |   88 ++++++--
>  11 files changed, 532 insertions(+), 721 deletions(-)
>  delete mode 100644 drivers/mfd/max8997-irq.c
> 

This patch fix many parts of previous max8997.
When I testd kernel build, it is ok. 

But, I have a question.
The max8997 is used on trats board based on exynos4210.
Did you test this patchset?

Best Regards,
Chanwoo Choi

