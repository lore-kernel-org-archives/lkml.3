Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3LCLFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:05:32 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41330 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3LCLFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:05:30 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rB3B5Lul016119, This message is accepted by code: ctloc85258
Message-ID: <529DBB70.2070600@realsil.com.cn>
Date: Tue, 3 Dec 2013 19:07:28 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, <rogerable@realtek.com>
Subject: Re: [PATCH v2 3/3] mfd: rtsx: prevent 'used uninitialised' warnings
References: <cover.1386051860.git.micky_ching@realsil.com.cn> <932dcc03570ceb86316272d4eba7f4207d001def.1386051860.git.micky_ching@realsil.com.cn> <20131203104003.GJ11828@lee--X1> <529DB86D.3010002@realsil.com.cn> <20131203110138.GN11828@lee--X1>
In-Reply-To: <20131203110138.GN11828@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 07:01 PM, Lee Jones wrote:
>>> This should contain the author's name.
>>>
>>> You should use:
>>>     `git rebase -i` /* Use edit option */
>>> then
>>>    `git commit --amend --author="First Last <first.last@email.com>"
>>>
>>> To apply it.
>>>
>> Sorry Lee, I will modify it. Is the order important? or only your
>> name is need here?
>>>> drivers/mfd/rtl8411.c: In function 'rtl8411_fetch_vendor_settings':
>>>> drivers/mfd/rtl8411.c:58:7: warning: 'reg1' is used uninitialized in this function [-Wuninitialized]
>>>> drivers/mfd/rtl8411.c: In function 'rtl8411b_fetch_vendor_settings':
>>>> drivers/mfd/rtl8411.c:79:7: warning: 'reg' is used uninitialized in this function [-Wuninitialized]
>>>> drivers/mfd/rtl8411.c: In function 'rtl8411_fetch_vendor_settings':
>>>> drivers/mfd/rtl8411.c:69:26: warning: 'reg3' may be used uninitialized in this function [-Wuninitialized]
>>>>
>>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>> Tested-by: Micky Ching <micky_ching@realsil.com.cn>
>>> I know this is a bit of a strange situation, but whenever you sent
>>> patches to the MLs,  you need to sign it off yourself too.
> Actually, you don't need to worry now. I already applied the patch
> with the correct author applied with your Ack.
>
>> Did you mean I need write like this ?
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> Tested-by: Micky Ching <micky_ching@realsil.com.cn>
>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> As I say, this situation is a bit different, but in the normal case,
> yes. Then the Maintainer will probably remove some and chop them
> around a little to his/her liking.
>
> FYI: The top SoB is usually the author, the subsequent ones are
> usually gatekeepers of upstream repos. Anyone can take a patch and
> submit it though, so in the case where the submitter isn't the author,
> the second SoB is usually the patch submitter.
>
Thank you for your patient.

-- 
Best Regards
Micky.

