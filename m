Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3HULsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:48:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27065 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3HULs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:48:29 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-bd-5214a90cacd0
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-mmc@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1375825071-20922-1-git-send-email-dianders@chromium.org>
 <1376066000-5495-1-git-send-email-dianders@chromium.org>
In-reply-to: <1376066000-5495-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v5 0/4] mmc: dw_mmc: fixes for suspend/resume on exynos
Date: Wed, 21 Aug 2013 20:48:27 +0900
Message-id: <001e01ce9e64$59c3b780$0d4b2680$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6VHjiDDnV9/YB/S/qG/uRFjEzsKAJRaeww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t8zA12elSJBBt9281s8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurRe+Cq2wWmx5fY7W4vGsOm8WR//2MFjPO72Oy
	OHX9M5vFql1/GB34PGY3XGTx2DnrLrtHz84zjB6Hrqxl9Ni8pN7jyokmVo++LasYPT5vkgvg
	iOKySUnNySxLLdK3S+DKWPT3H2vBIv6KSY9aWBsYZ/J0MXJySAiYSFy6eIQVwhaTuHBvPVsX
	IxeHkMAyRomHF9vZYYq+Hf3GCJGYziix6dBXJgjnD6PErIa9jCBVbAJaEn/fvGEGsUUEvCRe
	7H7ADFLELHCVWWLNh0lQ7Q2MEov3vGQDqeIUcJU4OuUtE4gtLOAt8WPrNhYQm0VAVeL9hz6w
	OK+ArcSZpxNZIGxBiR+T74HZzAIGEu9n9bFC2PISm9e8BdrGAXSrusSjv7oQRxhJvPm8mx2i
	RERi34t3YDdICOzgkDg56QETxC4BiW+TD7FA9MpKbDrADPGypMTBFTdYJgD9h2TzLCSbZyHZ
	PAvJigWMLKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQpLEhB2M9w5YH2JMBlo/kVlKNDkf
	mGTySuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAo
	mMLKc+DoD5HFUZ7bdK79kVi69sP655/Wmb41fOJf25wwrfjiiyOpu0+etH1WY1X/raFbxPhq
	4fTg16b7dq5gu+b3cr2ujDfz0ntuuz+bWb88f1iGd/5hhYdL2dPW3U+c5/WiYt2HHZE/Tj+q
	VK+qncKkkStjLdi5fqabCHOzx+mMZROPz94YosRSnJFoqMVcVJwIAPNKwg4oAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsVy+t9jQV2elSJBBvsec1o8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHHjVxurRe+Cq2wWmx5fY7W4vGsOm8WR//2MFjPO72Oy
	OHX9M5vFql1/GB34PGY3XGTx2DnrLrtHz84zjB6Hrqxl9Ni8pN7jyokmVo++LasYPT5vkgvg
	iGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlxJ
	oSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLHo7z/WgkX8FZMetbA2MM7k
	6WLk5JAQMJH4dvQbI4QtJnHh3nq2LkYuDiGB6YwSmw59ZYJw/jBKzGrYC1bFJqAl8ffNG2YQ
	W0TAS+LF7gfMIEXMAleZJdZ8mMQI0dHAKLF4z0s2kCpOAVeJo1PeMoHYwgLeEj+2bmMBsVkE
	VCXef+gDi/MK2EqceTqRBcIWlPgx+R6YzSxgIPF+Vh8rhC0vsXnNW6BtHEC3qks8+qsLcYSR
	xJvPu9khSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIEp6Bn0jsYVzVYHGIU4GBU4uG9oCwSJMSaWFZcmXuIUYKDWUmEd1E1UIg3JbGyKrUo
	P76oNCe1+BBjMtCjE5mlRJPzgekxryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6Yklqdmp
	qQWpRTBbmDg4pRoY84+xW0/4JBRivqh/gvr3xR957igHGzPY/1vrMCnjVvb6d4vYPDt/zd7k
	9+SWt9Wp/KgfR7/8NWM8Eb9v8fWTDuItoYLvH941nL7JQveSWVTsvNxvl54LhByMKmy/quay
	TrSihWGPfYvm/BnHVbJShGStemf3T/67f+t8s+9i0XtVZgo3Vqx1UmIpzkg01GIuKk4EAEzk
	yXaFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,
Do you have any update for this series?
Please let me know.

Thanks,
Seungwon Jeon

On Sat, August 10, 2013, Doug Anderson wrote:
> This series of patches addresses some suspend/resume problems with
> dw_mmc on exynos platforms, espeically exynos5420.  Since
> suspend/resume is not fully working on ToT Linux (v3.11-rc4) on
> exynos5250-snow, this series was tested against the current ToT
> ChromeOS 3.8 tree.  I have confirmed basic booting and eMMC / SD card
> usage (and compiling, honest!) against ToT Linux.
> 
> I have received confirmation from Samsung that the problem solved is a
> silicon errata on exynos5420 and that this is a good fix.
> 
> Changes in v5:
> - Remove force_clkinit as per Jaehoon.
> - Update commit message to (hopefully) be clearer.
> - Cleaned up dw_mci_exynos_resume_noirq() comment as per Seungwon.
> - Don't memcpy dev_pm_ops structure, define a new one.
> 
> Changes in v4:
> - Take Seungwon's suggestion and don't add any dw_mmc-pltfm code.
> 
> Changes in v3:
> - Add freeze/thaw and poweroff/restore noirq entries.
> 
> Changes in v2:
> - Fix typo (some -> come)
> - Use ~0 instead of 0xFFFFFFFF; add comment about value
> - Use suspend_noirq as per James Hogan.
> 
> Doug Anderson (4):
>   mmc: dw_mmc: Invalidate cache of current_speed after suspend/resume
>   mmc: dw_mmc: Add exynos resume_noirq callback to clear WAKEUP_INT
>   mmc: dw_mmc: Always setup the bus after suspend/resume
>   mmc: dw_mmc: Set timeout to max upon resume
> 
>  drivers/mmc/host/dw_mmc-exynos.c | 56 +++++++++++++++++++++++++++++++++++++++-
>  drivers/mmc/host/dw_mmc.c        | 21 ++++++++++-----
>  2 files changed, 69 insertions(+), 8 deletions(-)
> 
> --
> 1.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

