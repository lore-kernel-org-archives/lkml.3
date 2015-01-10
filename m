Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbbAJSj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 13:39:26 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbbAJSjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:39:24 -0500
Message-ID: <54B171D8.6020301@nod.at>
Date: Sat, 10 Jan 2015 19:39:20 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, Harald Geyer <harald@ccbib.org>
CC: knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/3,RESEND] iio: dht11: Fix out-of-bounds read
References: <1417563176-31972-1-git-send-email-richard@nod.at> <54A53FBF.5000003@kernel.org> <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net> <54A680F8.30209@nod.at> <54A91DA1.6080107@kernel.org> <E1Y881p-0001Fp-NX@stardust.g4.wien.funkfeuer.at> <54AA97B9.7040703@nod.at> <E1Y8pWE-00012g-Ec@stardust.g4.wien.funkfeuer.at> <54B10997.6090708@kernel.org>
In-Reply-To: <54B10997.6090708@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.01.2015 um 12:14 schrieb Jonathan Cameron:
> On 07/01/15 12:15, Harald Geyer wrote:
>> As we access i-1 we must not start with i=0.
>>
>> From: Richard Weinberger <richard@nod.at>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
>> Acked-by: Harald Geyer <harald@ccbib.org>
>> Reviewed-by: Sanjeev Sharma <sanjeev_sharma@mentor.com>
>> ---
>> Resending again to get the metadata right.
> Putting a From: in doesn't work, you need to use git commit --amend --author to
> fix it up.

Or just use "git am" to apply a patch to a tree and keep the original author.
If you use "git format-patch" later it will produce the correct "From:".


Thanks,
//richard
