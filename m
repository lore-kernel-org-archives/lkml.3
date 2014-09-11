Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaIKCSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 22:18:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43556 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaIKCSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 22:18:51 -0400
X-AuditID: cbfee68e-f79536d000000fd1-5c-54110689f3dd
Message-id: <54110688.30604@samsung.com>
Date: Thu, 11 Sep 2014 11:18:48 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Alim Akhtar <alim.akhtar@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Chris Ball <chris@printf.net>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: Re: [PATCH] mmc: dw_mmc: add support for ARM64
References: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com>
 <CAPDyKFqk1pwGFuitE0Fk1pqyP_FZiQK1=5OtGUM9Zw6Mp_rWXw@mail.gmail.com>
 <CAGOxZ506d5FNs1mZTX=ck9WPZsqzR+3ON-aKS2P8v5_iRyFV7w@mail.gmail.com>
In-reply-to: <CAGOxZ506d5FNs1mZTX=ck9WPZsqzR+3ON-aKS2P8v5_iRyFV7w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkULeTTTDEYMUjAYuV7/8yWiy9VW3x
	YN42Nou/k46xW0y4vJ3R4vKuOWwWR/73M1p8uH+R2eL42nCLs6fKHbg8fv+axOgxu+Eii8fO
	WXfZPe5c28PmcePVQiaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgyrhyaiNbQbtgRef1z8wN
	jCd5uxg5OSQETCTO75nPBmGLSVy4tx7MFhJYyijR8oYTpqZt1jzWLkYuoPgiRonfB9YxQziv
	GSVuvN3NDFLFK6AhsXjGFEYQm0VAVWLdv5ssIDabgI7E9m/HmUBsUYEwiUNt85gg6gUlfky+
	B1YjIuAr0T/zADvIUGaBu0wS//5tBXI4OIQFzCU+nBKDWHaVUWLjhLNgyzgFgiUe7toHdiqz
	gLrEpHmLmCFseYnNa96CXSch8JVd4uO6BjaIiwQkvk0+xAIyVEJAVmLTAWaI1yQlDq64wTKB
	UWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECo/T0v2d9OxhvHrA+
	xCjAwajEw1vBIhgixJpYVlyZe4jRFOiKicxSosn5wFSQVxJvaGxmZGFqYmpsZG5ppiTOmyD1
	M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD44TCmcKc3yp3/7iSuf9nWDuPquUfC1PpChnG
	j/Er9OpE3u+O9T08w0tCNbv+nnV4prpC6qYf2b1GBtkqlusaSgJuhd32WHNww651S+7Yuqzx
	K5wZNGHaQ26+WkGDcD8lnb+e3B5nd/373R+5pvlxAsOULRmKXq/Uq34IP/K10bj6T+Nw4TQ/
	JZbijERDLeai4kQAVg+Ho80CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xgG4nm2CIwYObHBYr3/9ltFh6q9ri
	wbxtbBZ/Jx1jt5hweTujxeVdc9gsjvzvZ7T4cP8is8XxteEWZ0+VO3B5/P41idFjdsNFFo+d
	s+6ye9y5tofN48arhUwefVtWMXp83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjHjyqmNbAXtghWd1z8zNzCe5O1i5OSQEDCRaJs1jxXCFpO4cG89WxcjF4eQwCJG
	id8H1jFDOK8ZJW683c0MUsUroCGxeMYURhCbRUBVYt2/mywgNpuAjsT2b8eZQGxRgTCJQ23z
	mCDqBSV+TL4HViMi4CvRP/MAO8hQZoG7TBL//m0Fcjg4hAXMJT6cEoNYdpVRYuOEs2DLOAWC
	JR7u2scGYjMLqEtMmreIGcKWl9i85i3zBEaBWUh2zEJSNgtJ2QJG5lWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwUngmdQOxpUNFocYBTgYlXh4K1gEQ4RYE8uKK3MPMUpwMCuJ8CY8EAgR
	4k1JrKxKLcqPLyrNSS0+xGgKDIKJzFKiyfnABJVXEm9obGJmZGlkbmhhZGyuJM57oNU6UEgg
	PbEkNTs1tSC1CKaPiYNTqoFRwHKz3x1h3fKN8xbp9j38ksw0t/26kXrfbg8FjmVa9zfcSzl6
	Wuv3lNT4zd//xlV+bNf8cW7lsqvTtNrmHj2Rrxl0vVKnS/I/v8yb3lZz1evTTulcmqoyqU/3
	aqnFo4OzPj/eGG/ONH1zoMp/TTlrX54ebq8dl8tZNMSrf2yu6v8xgy1CdTWbEktxRqKhFnNR
	cSIADS5F6RgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 08:31 PM, Alim Akhtar wrote:
> Hi Ulf,
> 
> On Tue, Sep 9, 2014 at 12:21 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> On 29 August 2014 12:24, Alim Akhtar <alim.akhtar@samsung.com> wrote:
>>> There are upcoming ARM64 SoCs with dw_mmc host controller.
>>>
>>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>>> ---
>>>  drivers/mmc/host/Kconfig |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
>>> index a43295c..72dd6c2 100644
>>> --- a/drivers/mmc/host/Kconfig
>>> +++ b/drivers/mmc/host/Kconfig
>>> @@ -580,7 +580,7 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
>>>  config MMC_DW
>>>         tristate "Synopsys DesignWare Memory Card Interface"
>>>         depends on HAS_DMA
>>> -       depends on ARC || ARM || MIPS || COMPILE_TEST
>>> +       depends on ARC || ARM || ARM64 || MIPS || COMPILE_TEST
>>
>> Before enabling this, wouldn't it be better to add the needed support
>> in dw_mmc first? Or there are no changes needed?
>>
>> There are also ongoing development and discussions for exynos7, which
>> I guess relates to this?
>> http://www.spinics.net/lists/linux-mmc/msg28294.html
> Thanks for looking into this.
> 
> Yes, this patch is being tested on exynos7 platform which is ongoing
> development.
> The above link is one of them.
> I feel this patch is too generic in nature and we now known at least
> exynos7 is going to use this.
> I don't know if there are any other ARM64 platform with dw_mmc controller.

If we need to prepare the ARM64, the above patch(linked patch) has to merge, why not?
But it needs to test for other SoCs and rework it.

Best Regards,
Jaehoon Chung

> 
> So, I am going to leave this upto you to decide when to take this
> patch, incase you decided to take it after exynos7 support lands, I
> will send a reminder for this.
>>
>> Kind regards
>> Uffe
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

