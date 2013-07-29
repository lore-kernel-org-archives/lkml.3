Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3G2B6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 21:58:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62464 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3G2B6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 21:58:38 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-46-51f5cc4ad6ac
From: Jingoo Han <jg1.han@samsung.com>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: "'Daniel Jeong'" <daniel.jeong@ti.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <1374829330-20603-1-git-send-email-daniel.jeong@ti.com>
In-reply-to: <1374829330-20603-1-git-send-email-daniel.jeong@ti.com>
Subject: Re: [PATCH v1] backlight-lm3630-apply chip revision
Date: Mon, 29 Jul 2013 10:58:33 +0900
Message-id: <009701ce8bff$21cae730$6560b590$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIL2tecdEDowa68rXp4Hct3pyJUcpkAPnSw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zY12vM18DDbrniljMWb+GzeLlIU2L
	PdueMltM3t3FanF54SUgsWsOm8XuXU9ZHdg9ds66y+5xYsZvFo8983+wevRtWcXocfzGdiaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDKmT7vOWNAjVLG2cSpbA+Nqvi5GTg4JAROJJ6d7mCBsMYkL
	99azdTFycQgJLGOUWH58FitM0a9Z61kgEosYJdb8uMAK4fxilNh6fx9YFZuAmsSXL4fZuxg5
	OEQENCV2LakBqWEWOMgo8er5BLAaIQFniT9duxhBajgFXCSOLq8GCQsL2Eg0XFvICGKzCKhK
	PFu7lQXE5hWwlJj1/T4rhC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMkMcqiCx4+xrsDkiAkYS
	jZu7oOpFJPa9eMcIco+EwFd2iUf9v5ghlglIfJt8iAXkHgkBWYlNB6DmSEocXHGDZQKjxCwk
	q2chWT0LyepZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESx707GG8fsD7EmAy0
	fiKzlGhyPjAN5JXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBschl5SbD+XuWG9+Rlqs+4LZkqV+ERd/77aorO+zkbfm/rf5zr33RjS1bp748NDva
	6L3lQVHxztCSxCOtvEm2yXt1P7c/5eZMO/v6eYCUr36wWYT94ppvdx9a3C7aubpL6MtExrA/
	D34aMe6Yf22NFc++7//lT/sYTPLxv1k/bd7+xY9SE3+IdSmxFGckGmoxFxUnAgC8l7Pu+QIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAV2vM18DDV584beYs34Nm8XLQ5oW
	e7Y9ZbaYvLuL1eLywktAYtccNovdu56yOrB77Jx1l93jxIzfLB575v9g9ejbsorR4/iN7Uwe
	nzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gDdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmD7tOmNBj1DF2sap
	bA2Mq/m6GDk5JARMJH7NWs8CYYtJXLi3nq2LkYtDSGARo8SaHxdYIZxfjBJb7+9jBaliE1CT
	+PLlMHsXIweHiICmxK4lNSA1zAIHGSVePZ8AViMk4Czxp2sXI0gNp4CLxNHl1SBhYQEbiYZr
	CxlBbBYBVYlna7eCLeYVsJSY9f0+K4QtKPFj8j2wOLOAlsT6nceZIGx5ic1r3jJDHKogsePs
	a7A5IgJGEo2bu6DqRST2vXjHOIFRaBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfm
	Fpfmpesl5+duYgQniWfSOxhXNVgcYhTgYFTi4X3g9CVQiDWxrLgy9xCjBAezkggvh9HXQCHe
	lMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3OByawvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJ
	pCeWpGanphakFsFsYeLglGpgrF5wenrINzVjXgXemJKUO580A0IiKmS/rr0c+yHq+rRVgTkT
	AkUmrNjgtrDI4bOawa2ScmmB/93+OdMFJ9W8lPiccvTke1fDzWcCFsfyLmgJ9tNkuskfv6fw
	++/+Jy9CXl+ZZyG/iWvSLjPhXds3a+9W4orhW5oQcT7uvPjPXZtENrdVHfhjrsRSnJFoqMVc
	VJwIAHoGc9lWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 26, 2013 6:02 PM, Daniel Jeong wrote:
> Subject: [PATCH v1] backlight-lm3630-apply chip revision

Please don't use this subject, as I mentioned.
Also, this patch version is v2.

Thus, when you send the next version of this patch,
you should use the subject as below:

[PATCH v3] backlight: lm3630: apply chip revision

According to 'Documentation/SubmittingPatches',
15) The canonical patch format
The canonical patch subject line is:
    Subject: [PATCH 001/123] subsystem: summary phrase

> 
> The LM3630 chip was revised by TI and chip name was also changed to LM3630A.
> And register map, default values and intiial sequences are changed.

Looks good.


> lm3630_bl.c and .h files are deleted
> lm3630_bla.c and .h files are added

Fix the typo: lm3630_bla.c -> lm3630a_bl.c

The following is simpler.
lm3630_bl.{c,h} files are changed to lm3630a_bl.{c,h}.


> www.ti.com
>

Please, don't add meaningless commit message.
If you want to mention web address of your company,
please mention what it means as below:

The full datasheets are available from TI website:
http://www.ti.com/product/lm3630a


> Signed-off-by: daniel jeong <daniel.jeong@ti.com>

Please use upper case as below:
Signed-off-by: Daniel Jeong <daniel.jeong@ti.com>
                   ^^^     ^^^

In my opinion, you have to fix your .gitconfig file as below:

[user]
        email = daniel.jeong@ti.com
        name = Daniel Jeong

Daniel Jeong,
Please, read the './Documentation/SubmittingPatches', before you send
your patch.


Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/Kconfig          |    6 +-
>  drivers/video/backlight/Makefile         |    2 +-
>  drivers/video/backlight/lm3630_bl.c      |  475 -----------------------------
>  drivers/video/backlight/lm3630a_bl.c     |  482 ++++++++++++++++++++++++++++++
>  include/linux/platform_data/lm3630_bl.h  |   57 ----
>  include/linux/platform_data/lm3630a_bl.h |   65 ++++
>  6 files changed, 551 insertions(+), 536 deletions(-)
>  delete mode 100644 drivers/video/backlight/lm3630_bl.c
>  create mode 100644 drivers/video/backlight/lm3630a_bl.c
>  delete mode 100644 include/linux/platform_data/lm3630_bl.h
>  create mode 100644 include/linux/platform_data/lm3630a_bl.h
> 


