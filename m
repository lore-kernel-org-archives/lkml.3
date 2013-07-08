Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3GHPKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:10:47 -0400
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:11147 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3GHPKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:10:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,1020,1363158000"; 
   d="scan'208";a="47058295"
X-IronPort-AV: E=Sophos;i="4.87,1020,1363158000"; 
   d="scan'208";a="501526174"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <sedat.dilek@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>,
        LKML <linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: ath10k mailing list and new git tree
References: <87r4f9cf0w.fsf@kamboji.qca.qualcomm.com>
	<CA+icZUU32347g48dpk-gVZZ1H9pvnjaSWpQ12B-5vOkLzs8Nbg@mail.gmail.com>
Date: Mon, 8 Jul 2013 18:10:34 +0300
In-Reply-To: <CA+icZUU32347g48dpk-gVZZ1H9pvnjaSWpQ12B-5vOkLzs8Nbg@mail.gmail.com>
	(Sedat Dilek's message of "Mon, 8 Jul 2013 16:58:46 +0200")
Message-ID: <877gh1cck5.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> writes:

> On Mon, Jul 8, 2013 at 4:17 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Hi,
>>
>> we have a new mailing list for ath10k, please use that in the future
>> instead of ath9k-devel:
>>
>> http://lists.infradead.org/mailman/listinfo/ath10k
>>
>> As ath10k is now in wireless-next please use the new git tree which is
>> for both ath6kl and ath10k:
>>
>> https://github.com/kvalo/ath
>>
>> I have also updated the wiki accordingly:
>>
>> http://wireless.kernel.org/en/users/Drivers/ath10k
>>
>
> You have sent these new informations for MAINTAINERS file to upstream?

Good point. Actually MAINTAINERS entry for ath10k is completely missing,
I'll send a patch for that.

Thanks.

-- 
Kalle Valo
