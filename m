Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaINBM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 21:12:27 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41523 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaINBMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 21:12:24 -0400
Message-ID: <5414EB70.3080105@samsung.com>
Date: Sun, 14 Sep 2014 10:12:16 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: balbi@ti.com, Kukjin Kim <kgene.kim@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] usb: phy: samsung: remove old USB PHY code
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com> <20140820181244.GX24500@saruman.home> <9785858.kcvmMFDl1x@amdc1032>
In-Reply-To: <9785858.kcvmMFDl1x@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/14 02:14, Bartlomiej Zolnierkiewicz wrote:
>
> Hi,
>
> On Wednesday, August 20, 2014 01:12:44 PM Felipe Balbi wrote:
>> Hi,
>>
>> On Thu, Aug 14, 2014 at 04:25:22PM +0200, Bartlomiej Zolnierkiewicz wrote:
>>> Hi,
>>>
>>> This patch series removes the old Samsung USB PHY drivers that
>>> got replaced by the new ones using the generic PHY layer.
>>>
>>> Depends on:
>>> - next-20140813 branch of linux-next kernel
>>
>> this thread seems to have died, what do I need to do with these patches?
>
> Please apply them (patches #3, #4 and #5).  Patches #1 and #2
> should be applied (or Acked-by) by Kukjin Kim.
>
I've applied #1 and #2, sorry for late taking.

Thanks,
Kukjin

>> Are we deleting the phy drivers or not ?
>
> Yes, we are deleting them.  It has been agreed on by Kishon and
> Vivek.
>
>> Please rebase on v3.17-rc1 and resend with all Acks in place.
>
> Done:
>
> 	https://lkml.org/lkml/2014/8/22/446
>
> Please note that if you want to apply it to current -next kernel
> (next-20140822) then you need to resolve conflict between patch
> #5/5 ("usb: phy: samsung: remove old common USB PHY code") and
> commit bbc66e140bab ("usb: phy: samsung: Fix wrong bit mask for
> PHYPARAM1_PCS_TXDEEMPH") by simply removing the new version of
> drivers/usb/phy/phy-samsung-usb.h file.
