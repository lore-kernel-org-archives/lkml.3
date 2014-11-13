Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaKMCNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:13:07 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37739 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaKMCNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:13:04 -0500
Message-ID: <546413A7.1050803@samsung.com>
Date: Thu, 13 Nov 2014 11:12:55 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Javier Martinez Canillas <javier@dowhile0.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk> <1413839151-10875-3-git-send-email-javier.martinez@collabora.co.uk> <CABxcv==YZjO9p3aNyuRpe3DYS+=BcY_N2esuTg0hGASb_b_OdA@mail.gmail.com> <CABxcv=mMqh5UD0_Wz3rNaFbZD3BH_2Z+7srzccd=-5_ndo_a1Q@mail.gmail.com> <CAOesGMjKP6Yg-M_7Zy5bbEJ7QD7fQ27Bopd6yD3M=r=4SArR6w@mail.gmail.com>
In-Reply-To: <CAOesGMjKP6Yg-M_7Zy5bbEJ7QD7fQ27Bopd6yD3M=r=4SArR6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/14 02:02, Olof Johansson wrote:
> On Tue, Nov 11, 2014 at 2:23 AM, Javier Martinez Canillas
> <javier@dowhile0.org>  wrote:
>> Hello Kukjin,
>>
>> On Thu, Oct 30, 2014 at 11:06 AM, Javier Martinez Canillas
>> <javier@dowhile0.org>  wrote:
>>> Hello Kukjin,
>>>
>>> On Mon, Oct 20, 2014 at 11:05 PM, Javier Martinez Canillas
>>> <javier.martinez@collabora.co.uk>  wrote:
>>>> The regulator framework has a set of helpers functions to be used when
>>>> the system is entering and leaving from suspend but these are not called
>>>> on Exynos platforms. This means that the .set_suspend_* function handlers
>>>> defined by regulator drivers are not called when the system is suspended.
>>>>
>>>> Suggested-by: Doug Anderson<dianders@chromium.org>
>>>> Signed-off-by: Javier Martinez Canillas<javier.martinez@collabora.co.uk>
>>>> Reviewed-by: Doug Anderson<dianders@chromium.org>
>>>> ---
>>>>   arch/arm/mach-exynos/suspend.c | 23 +++++++++++++++++++++++
>>>>   1 file changed, 23 insertions(+)
>>>>
>>>
>>> Any comments on this patch?
>>>
>>
>> Just a gentle reminder about this patch.
>
> Kukjin, should I just apply this directly since you seem to be busy?
>
Oh, sorry. I'm here and applying this patch into samsung tree.

Thanks,
Kukjin
