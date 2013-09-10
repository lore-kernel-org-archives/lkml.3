Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab3IJBKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:10:04 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:34597 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3IJBKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:10:03 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r8A19dHw026226, This message is accepted by code: ctloc85258
Message-ID: <522E7154.7060706@realsil.com.cn>
Date: Tue, 10 Sep 2013 09:09:40 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v2] mfd: rtsx: Modify rts5249_optimize_phy
References: <cover.1378437776.git.wei_wang@realsil.com.cn> <e858b38c5b87dd761c764c6214f49cf9a9b5ad1d.1378437776.git.wei_wang@realsil.com.cn> <20130909130211.GG22938@lee--X1>
In-Reply-To: <20130909130211.GG22938@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年09月09日 21:02, Lee Jones 写道:
>>   #define PHY_FLD4			0x1E
>> >+#define  FLDEN_SEL			0x4000
>> >+#define  REQ_REF			0x2000
>> >+#define  RXAMP_OFF			0x1000
>> >+#define  REQ_ADDA			0x0800
>> >+#define  BER_COUNT			0x00E0
>> >+#define  BER_TIMER			0x000A
>> >+#define  BER_CHK_EN			0x0001
>> >  #define PHY_DUM_REG			0x1F
>> >  
>> >  #define LCTLR				0x80
> This doesn't look right.
>
> We had a nicely structured, ordered list and now you've seemingly
> randomly shoved a truck load of un-prefixed defines between them.
>
> Am I missing something? Is there method to the madness?

Hi Lee:

Are you suggesting that I should define the macros using the same prefix 
like below?

#define PHY_FLD4                        0x1E
#define   FLD4_FLDEN_SEL          0x4000
#define   FLD4_REQ_REF              0x2000
#define   FLD4_RXAMP_OFF        0x1000


BR,
Wei
