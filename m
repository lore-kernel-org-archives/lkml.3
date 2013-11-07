Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3KGK6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:58:54 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51251 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3KGK6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:58:52 -0500
MIME-Version: 1.0
In-Reply-To: <1864683.tCrpAXuim8@amdc1032>
References: <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
 <1383803562-31752-1-git-send-email-ch.naveen@samsung.com> <1864683.tCrpAXuim8@amdc1032>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 7 Nov 2013 16:28:31 +0530
Message-ID: <CAHfPSqBjTpCyKaR03t_cd3JrhX_6tfwsBFuHEG1v1=qn1OqyrQ@mail.gmail.com>
Subject: Re: [PATCH 1/3 v8] thermal: samsung: add intclr_fall_shift bit in
 exynos_tmu_register struct
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, eduardo.valentin@ti.com,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On 7 November 2013 16:18, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
>
> Hi,
>
> On Thursday, November 07, 2013 11:22:42 AM Naveen Krishna Chatradhi wrote:
>> On Exynos5250, the FALL interrupt related en, status and clear bits are
>> available at an offset of
>> 16 in INTEN, INTSTAT registers and at an offset of
>> 12 in INTCLEAR register.
>>
>> On Exynos5420, the FALL interrupt related en, status and clear bits are
>> available at an offset of
>> 16 in INTEN, INTSTAT and INTCLEAR registers.
>>
>> On Exynos5440,
>> the FALL_IRQEN bits are at an offset of 4
>> and the RISE_IRQEN bits are at an offset of 0
>>
>> This patch introduces a new bit field intclr_fall_shift to handle the
>> offset for exyns5250 and exynos5440
>> Also removes the unused macros EXYNOS_TMU_FALL_INT_SHIFT and
>> EXYNOS5440_TMU_FALL_INT_SHIFT, inten_fall_shift field
>
> Thanks for fixing this.  All three patches look good to me now.
>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Thanks for all the following up.
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>



-- 
Shine bright,
(: Nav :)
