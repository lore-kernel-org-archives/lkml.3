Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaIKEpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 00:45:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16791 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaIKEpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 00:45:06 -0400
X-AuditID: cbfee68f-f797f6d000001173-5e-541128cfff29
Message-id: <541128CE.9060804@samsung.com>
Date: Thu, 11 Sep 2014 13:45:02 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Alim Akhtar <alim.akhtar@gmail.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>
Subject: Re: [PATCH] mmc: dw_mmc: add support for ARM64
References: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com>
 <CAPDyKFqk1pwGFuitE0Fk1pqyP_FZiQK1=5OtGUM9Zw6Mp_rWXw@mail.gmail.com>
 <CAGOxZ506d5FNs1mZTX=ck9WPZsqzR+3ON-aKS2P8v5_iRyFV7w@mail.gmail.com>
 <54110688.30604@samsung.com>
 <CAGOxZ50Jy8YCb4v77MhdnDqfVOe6bvssrdnojEBiPuCE9RDLmA@mail.gmail.com>
In-reply-to: <CAGOxZ50Jy8YCb4v77MhdnDqfVOe6bvssrdnojEBiPuCE9RDLmA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkWPe8hmCIwZbzghYr3/9ltFh6q9ri
	wbxtbBZ/Jx1jt5hweTujxeVdc9gsjvzvZ7T4cP8is8XxteEWZ0+VO3B5/P41idFjdsNFFo+d
	s+6ye9y5tofN48arhUwefVtWMXp83iQXwB7FZZOSmpNZllqkb5fAlfG7ZzVTwQ/ximn959kb
	GCcIdzFyckgImEhs/dfHBmGLSVy4tx7I5uIQEljKKPFvUz9zFyMHWNHUzQIgNUICixgl/l6o
	hKh5zSixcf9FZpAEr4CWxIH5t5lAbBYBVYk525+wgthsAjoS278dB4uLCoRJHGqbxwRRLyjx
	Y/I9FhBbREBd4uX9jawgQ5kFWpklJh+aCrZYWMBc4sMpMYhlu5kk2qd0M4I0cAoES0zo6GQH
	sZmBmifNW8QMYctLbF7zlhmkQULgK7vEl9u7WSEuEpD4NvkQC8Q3shKbDjBDfCwpcXDFDZYJ
	jGKzkNw0C8nYWUjGLmBkXsUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGKOn/z3r38F494D1
	IUYBDkYlHt4KFsEQIdbEsuLK3EOMpkBXTGSWEk3OByaCvJJ4Q2MzIwtTE1NjI3NLMyVx3oVS
	P4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MNo++avJIRxVKh5f7vOcb+WazbxvflYbbfOe
	ohJwPS9a9df2dcfzJsl967WojdzJ511W+Sa1eWfhreui/TMXihf0cgSv+Gnq9n6LeuAdr9QE
	+eVJfi2WUf02HDqsyz7b7CnTnsLy/dbXRXOPWKSsnd9hdnNWBlfq4jkMTyxtlH88jt37YdfD
	KiWW4oxEQy3mouJEAIo0pkTMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgO55DcEQg1NHuCxWvv/LaLH0VrXF
	g3nb2Cz+TjrGbjHh8nZGi8u75rBZHPnfz2jx4f5FZovja8Mtzp4qd+Dy+P1rEqPH7IaLLB47
	Z91l97hzbQ+bx41XC5k8+rasYvT4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWPG757VTAU/xCum9Z9nb2CcINzFyMEhIWAiMXWzQBcjJ5ApJnHh3no2EFtIYBGj
	xN8LlV2MXED2a0aJjfsvMoMkeAW0JA7Mv80EYrMIqErM2f6EFcRmE9CR2P7tOFhcVCBM4lDb
	PCaIekGJH5PvsYDYIgLqEi/vb2QFGcos0MosMfnQVGaQI4QFzCU+nBKDWLabSaJ9SjcjSAOn
	QLDEhI5OdhCbGah50rxFzBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECE4Az6R3MK5qsDjEKMDBqMTDW8kiGCLEmlhWXJl7iFGCg1lJhDfhgUCI
	EG9KYmVValF+fFFpTmrxIUZTYBBMZJYSTc4HJqe8knhDYxMzI0sjc0MLI2NzJXHeg63WgUIC
	6YklqdmpqQWpRTB9TBycUg2MM+503n/aenvXctMPPyr298gHvWgw0X3cczz8I1/Inx7eb+EP
	6s7IlcYIR385N2tla//Pbzc9Hvfsny/BrC0c5ee2/U3ve7bas+IflzNrmpkvijbpU/qVzCIW
	u5lVxoJjf2EC48SHmfmpYQblk1t6TxY3K1Z3/9s1VbikYsZszxiHqyl/GFiVWIozEg21mIuK
	EwFlp33mFgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alim.

On 09/11/2014 11:35 AM, Alim Akhtar wrote:
> Hi Jaehoon,
> On Sep 11, 2014 11:18 AM, "Jaehoon Chung" <jh80.chung@samsung.com <mailto:jh80.chung@samsung.com>> wrote:
>>
>> On 09/09/2014 08:31 PM, Alim Akhtar wrote:
>> > Hi Ulf,
>> >
>> > On Tue, Sep 9, 2014 at 12:21 PM, Ulf Hansson <ulf.hansson@linaro.org <mailto:ulf.hansson@linaro.org>> wrote:
>> >> On 29 August 2014 12:24, Alim Akhtar <alim.akhtar@samsung.com <mailto:alim.akhtar@samsung.com>> wrote:
>> >>> There are upcoming ARM64 SoCs with dw_mmc host controller.
>> >>>
>> >>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com <mailto:alim.akhtar@samsung.com>>
>> >>> ---
>> >>>  drivers/mmc/host/Kconfig |    2 +-
>> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>>
>> >>> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
>> >>> index a43295c..72dd6c2 100644
>> >>> --- a/drivers/mmc/host/Kconfig
>> >>> +++ b/drivers/mmc/host/Kconfig
>> >>> @@ -580,7 +580,7 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
>> >>>  config MMC_DW
>> >>>         tristate "Synopsys DesignWare Memory Card Interface"
>> >>>         depends on HAS_DMA
>> >>> -       depends on ARC || ARM || MIPS || COMPILE_TEST
>> >>> +       depends on ARC || ARM || ARM64 || MIPS || COMPILE_TEST
>> >>
>> >> Before enabling this, wouldn't it be better to add the needed support
>> >> in dw_mmc first? Or there are no changes needed?
>> >>
>> >> There are also ongoing development and discussions for exynos7, which
>> >> I guess relates to this?
>> >> http://www.spinics.net/lists/linux-mmc/msg28294.html
>> > Thanks for looking into this.
>> >
>> > Yes, this patch is being tested on exynos7 platform which is ongoing
>> > development.
>> > The above link is one of them.
>> > I feel this patch is too generic in nature and we now known at least
>> > exynos7 is going to use this.
>> > I don't know if there are any other ARM64 platform with dw_mmc controller.
>>
>> If we need to prepare the ARM64, the above patch(linked patch) has to merge, why not?
> I am not in hurry to merge this now, as I said, its upto the maintainers to decide when to take this and I am ok with that.
>> But it needs to test for other SoCs and rework it.
> What rework you are anticipating here?

Sorry for confusing you. (I didn't see the above URL.)
You need to use this patch (http://www.spinics.net/lists/linux-mmc/msg21742.html), right?
Then need to rework it.

Best Regards,
Jaehoon Chung
> 
> Thanks.
>>
>> Best Regards,
>> Jaehoon Chung
>>
>> >
>> > So, I am going to leave this upto you to decide when to take this
>> > patch, incase you decided to take it after exynos7 support lands, I
>> > will send a reminder for this.
>> >>
>> >> Kind regards
>> >> Uffe
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> >> the body of a message to majordomo@vger.kernel.org <mailto:majordomo@vger.kernel.org>
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> >
>> >
>>
> 

