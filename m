Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaKSHvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:51:55 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:35460 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbaKSHvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:51:53 -0500
MIME-Version: 1.0
In-Reply-To: <546C4696.70101@samsung.com>
References: <1416199491-4841-1-git-send-email-a.kesavan@samsung.com>
	<20141117185925.GB14558@kroah.com>
	<546C4696.70101@samsung.com>
Date: Wed, 19 Nov 2014 13:21:52 +0530
Message-ID: <CAM4voan2t8inEtwJs9amQUBnT7eS5FUW=Z+a-5abQuFLjGi0sA@mail.gmail.com>
Subject: Re: [PATCH RESEND] serial: samsung: Fix serial config dependencies
 for exynos7
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On Wed, Nov 19, 2014 at 12:58 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> On 11/18/14 03:59, Greg KH wrote:
>> On Mon, Nov 17, 2014 at 10:14:51AM +0530, Abhilash Kesavan wrote:
>>> From: Pankaj Dubey <pankaj.dubey@samsung.com>
>>>
>>> Exynos7 has a similar serial controller to that present in older Samsung
>>> SoCs. To re-use the existing serial driver on Exynos7 we need to have
>>> SERIAL_SAMSUNG_UARTS_4 and SERIAL_SAMSUNG_UARTS selected. This is not
>>> possible because these symbols are dependent on PLAT_SAMSUNG which is
>>> not present for the ARMv8 based exynos7.
>>>
>>> Change the dependency of these symbols from PLAT_SAMSUNG to the serial
>>> driver thus making it available on exynos7. As the existing platform
>>> specific code making use of these symbols is related to uart driver this
>>> change in dependency should not cause any issues.
>>>
>>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
> Greg, thanks for your ack on this.
>
> Abhilash,
>
> I can't find the original patch in my mailbox, can you please re-send to
> me with adding Greg's ack?

Will send it you with Greg's Ack.

Thanks,
Abhilash
>
> Thanks,
> Kukjin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
