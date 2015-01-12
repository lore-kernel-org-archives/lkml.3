Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbbALL16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:27:58 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbbALL15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:27:57 -0500
Message-ID: <54B3AFB9.7030503@nod.at>
Date: Mon, 12 Jan 2015 12:27:53 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: Jonathan Cameron <jic23@kernel.org>, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, sanjeev_sharma@mentor.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/3,RESEND] iio: dht11: Fix out-of-bounds read
References: <1417563176-31972-1-git-send-email-richard@nod.at> <54A53FBF.5000003@kernel.org> <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net> <54A680F8.30209@nod.at> <54A91DA1.6080107@kernel.org> <E1Y881p-0001Fp-NX@stardust.g4.wien.funkfeuer.at> <54AA97B9.7040703@nod.at> <E1Y8pWE-00012g-Ec@stardust.g4.wien.funkfeuer.at> <54B10997.6090708@kernel.org> <54B171D8.6020301@nod.at> <E1YAd8v-0001FF-CI@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1YAd8v-0001FF-CI@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2015 um 12:26 schrieb Harald Geyer:
> Richard Weinberger writes:
>> Am 10.01.2015 um 12:14 schrieb Jonathan Cameron:
>>> On 07/01/15 12:15, Harald Geyer wrote:
>>>> As we access i-1 we must not start with i=0.
>>>>
>>>> From: Richard Weinberger <richard@nod.at>
>>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>>> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
>>>> Acked-by: Harald Geyer <harald@ccbib.org>
>>>> Reviewed-by: Sanjeev Sharma <sanjeev_sharma@mentor.com>
>>>> ---
>>>> Resending again to get the metadata right.
>>> Putting a From: in doesn't work, you need to use
>>> git commit --amend --author to fix it up.
>>
>> Or just use "git am" to apply a patch to a tree and keep the original author.
>> If you use "git format-patch" later it will produce the correct "From:".
> 
> Thats exactly what I did initially, but of course when pasting the
> patch into my MUA, the headers got lost. I guess you don't suggest that
> I forge your address, so what's the right way to handle this? Include
> the entire mbox file into the body of the message?

Use git send-email. :-)

Thanks,
//richard
