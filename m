Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaLXQ5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:57:55 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:44388 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaLXQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:57:54 -0500
MIME-Version: 1.0
In-Reply-To: <CA+ZZEcXCArW-6Fv9W=mLbEgQ_O2gMAwS1TLijovQPM+KU-3qeg@mail.gmail.com>
References: <CAD6G_RRFU_R6SHvc5C785qtJ1GTt_-HXhn83xXOxc=VAwPjdqQ@mail.gmail.com>
	<CA+ZZEcXCArW-6Fv9W=mLbEgQ_O2gMAwS1TLijovQPM+KU-3qeg@mail.gmail.com>
Date: Wed, 24 Dec 2014 16:57:53 +0000
Message-ID: <CAKv+Gu8RqcEEjCFrnwq4kGcasDunWcZ4PgfE_GSL1aO4MNj9xA@mail.gmail.com>
Subject: Re: ARM64 Crypto validation
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Jagannadha Teki <jteki@apm.com>
Cc: Jagan Teki <jagannadh.teki@gmail.com>,
        Yazen Ghannam <yazen.ghannam@linaro.org>,
        Steve Capper <steve.capper@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jagannadha Teki <jteki@amcc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 December 2014 at 11:47, Jagannadha Teki <jteki@apm.com> wrote:
> + Yazen Ghannam
> + Herbert Xu
> + Steve Capper
>
> On Tue, Dec 23, 2014 at 3:45 PM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
>> Hi,
>>
>> I need some information to validate arm64/crypto, do we have any
>> exact/defined way to validate this.
>>
>> Here are my findings:
>> 1. I see a dirty test module tcrypto.c where we need to give the sec
>> and mode module params as inputs.
>> 2. Validate through open crypto [1]
>>
>> Do we have any arm64 specific validations, Request for help.
>>
>> [1] http://sourceforge.net/projects/ocf-linux/
>
> thanks!
> --
> Jagan.
> CONFIDENTIALITY NOTICE: This e-mail message, including any attachments,
> is for the sole use of the intended recipient(s) and contains information
> that is confidential and proprietary to Applied Micro Circuits Corporation or its subsidiaries.
> It is to be used solely for the purpose of furthering the parties' business relationship.
> All unauthorized review, use, disclosure or distribution is prohibited.
> If you are not the intended recipient, please contact the sender by reply e-mail
> and destroy all copies of the original message.
>

Let's forget you sent this email, so you can start over and:
- work on your tone; I find it hard to care about what *you* need if
you don't take the time to introduce yourself, explain what you are
trying to accomplish, for what purpose and how and to which extent
that purpose aligns with that of our community
- think carefully about what validation of a crypto algorithm
implementation means, and whether it makes sense to do it in an arm64
specific way
- familiarize yourself with the way crypto code is checked for
correctness before it gets merged by Herbert (hint: it is related to
the dirty test module)
- assuming that you are working on Xgene, find out which algorithms in
arm64/crypto can even run on that chip, as it does not have the Crypto
Extensions
- get rid of the legalese footer, it has no place on an open source mailing list

Regards,
Ard.
