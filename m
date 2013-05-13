Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3EMG35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:29:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39939 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3EMG34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:29:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,659,1363158000"; 
   d="scan'208";a="46643284"
Message-ID: <74fe9162e1de73d086bd7e987a8fce6d.squirrel@www.codeaurora.org>
In-Reply-To: <002301ce4f8f$5bc02600$13407200$%jun@samsung.com>
References: <1368368640-10167-1-git-send-email-draviv@codeaurora.org>
    <1368368640-10167-4-git-send-email-draviv@codeaurora.org>
    <002301ce4f8f$5bc02600$13407200$%jun@samsung.com>
Date: Sun, 12 May 2013 23:29:55 -0700
Subject: RE: [PATCH V1 3/8] scsi: ufs: wrap the i/o access operations
From: "Dolev Raviv" <draviv@codeaurora.org>
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: "'Dolev Raviv'" <draviv@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Santosh Y'" <santoshsy@gmail.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sunday, May 12, 2013, Dolev Raviv wrote:
> Author should be identified here. (From: author...)
> Except last patch of series(8/8), all of patches are not from you.
>
>> Simplify operations with hiding mmio_base.
>>
>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> I'm not sure that your signed-off is proper here including (3/8 ~ 6/8)
> And maintainer, Santosh's ack is omitted.

Thanks for your comment I wasn't sure about the appropriate custom.
I will remove it later today if it is ok with you.

Dolev

>
>> Tested-by: Maya Erez <merez@codeaurora.org>
> Thanks,
> Seungwon Jeon
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


