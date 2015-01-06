Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbbAFFkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 00:40:16 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:65419 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbbAFFj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 00:39:57 -0500
MIME-Version: 1.0
In-Reply-To: <54AA97B9.7040703@nod.at>
References: <1417563176-31972-1-git-send-email-richard@nod.at>
	<54A53FBF.5000003@kernel.org>
	<7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net>
	<54A680F8.30209@nod.at>
	<54A91DA1.6080107@kernel.org>
	<E1Y881p-0001Fp-NX@stardust.g4.wien.funkfeuer.at>
	<54AA97B9.7040703@nod.at>
Date: Tue, 6 Jan 2015 11:09:56 +0530
Message-ID: <CAGUYZuTXy0SGzRKYA1TGtSr=aw_50n7Sy6E05WwTExqy_MGr-w@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] iio: dht11: Fix out-of-bounds read
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Harald Geyer <harald@ccbib.org>, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        sanjeevs1 <sanjeev_sharma@mentor.com>, linux-iio@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 7:25 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 05.01.2015 um 14:49 schrieb Harald Geyer:
>> As we access i-1 we must not start with i=0.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> Acked-by: Hartmut Knaack <knaack.h@gmx.de>
>> Acked-by: Harald Geyer <harald@ccbib.org>
     Reviewed-by: Sanjeev Sharma <sanjeev_sharma@mentor.com>
>> ---
>> Resending for Richard Weinberger.
>> No changes since v1 except reordering.
>
> I fear you got the resend wrong.
> The mail should be "From: Richard Weinberger <richard@nod.at>" to keep me
> as author and the SoB-Chain should have a "Signed-off-by: Harald Geyer <harald@ccbib.org>"
> at the end to indicate that this patch went though your hands.
>
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
