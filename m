Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbaHZNUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:20:54 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:32836 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101AbaHZNUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:20:53 -0400
Message-ID: <53FC89A0.8040905@st.com>
Date: Tue, 26 Aug 2014 15:20:32 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vince Bridgers <vbridgers2013@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        Ley Foon Tan <lftan@altera.com>, LeyFoon Tan <lftan.linux@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vince Bridgers <vbridger@altera.com>
Subject: Re: [PATCH] net: stmmac: add dcrs parameter
References: <1408967442-2724-1-git-send-email-lftan@altera.com>	<CAGb2v65fi=D_TQBSospft4T5OrBCj5TwQfgtkX=11M8TWFftYg@mail.gmail.com>	<53FB313C.9010808@st.com>	<CAOwfj2Oyy8EGxPhgJcgeGPMm3tJ9-fGOh5h7jU8q4_BO=vWrTA@mail.gmail.com>	<53FC1D68.1000600@st.com> <CAOwfj2MMJCYyqD9++MpbRZohzBXyX16fJY-FaT+8H2gZyJd9MA@mail.gmail.com>
In-Reply-To: <CAOwfj2MMJCYyqD9++MpbRZohzBXyX16fJY-FaT+8H2gZyJd9MA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.46]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_04:2014-08-26,2014-08-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2014 2:35 PM, Vince Bridgers wrote:
> Hi Peppe,
>
>>>
>>> In the Synopsys EMAC case, carrier sense is used to stop transmitting
>>> if no carrier is sensed during a transmission. This is only useful if
>>> the media in use is true half duplex media (like obsolete 10Base2 or
>>> 10Base5). If no one in using true half duplex media, then is it
>>> possible to set this disable by default? If we're not sure, then
>>> having an option feels like the right thing to do.
>>
>>
>> Indeed this is what I had done in the patch.
>>
>> http://git.stlinux.com/?p=stm/linux-sh4-2.6.32.y.git;a=commit;h=b0b863bf65c36dc593f6b7b4b418394fd880dae2
>>
>> Also in case of carrier sense the frame will be dropped in any case
>> later.
>>
>> Let me know if you Acked this patch so I will rebase it on
>> net.git and I send it soon
>>
>> peppe
>>
>
> Yes, this looks good to me. I don't expect anyone is using 10Base2 or
> 10Base5 anymore, so it's ok to disable DCRS by default.
>
> ack
>
> All the best,

thx so much, I will send this patch (with your Acked-by) and ported on
net.git soon.

Chen-Yu, Ley Foon, pls let me know if it is ok for you as well

Kind Regards
Peppe

>
> Vince
>
>

