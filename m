Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaLXLzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 06:55:35 -0500
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:40890 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751623AbaLXLzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 06:55:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAD6G_RRFU_R6SHvc5C785qtJ1GTt_-HXhn83xXOxc=VAwPjdqQ@mail.gmail.com>
References: <CAD6G_RRFU_R6SHvc5C785qtJ1GTt_-HXhn83xXOxc=VAwPjdqQ@mail.gmail.com>
Date: Wed, 24 Dec 2014 17:17:14 +0530
Message-ID: <CA+ZZEcXCArW-6Fv9W=mLbEgQ_O2gMAwS1TLijovQPM+KU-3qeg@mail.gmail.com>
Subject: Re: ARM64 Crypto validation
From: Jagannadha Teki <jteki@apm.com>
To: Jagan Teki <jagannadh.teki@gmail.com>,
        Yazen Ghannam <yazen.ghannam@linaro.org>,
        Steve Capper <steve.capper@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jagannadha Teki <jteki@amcc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Yazen Ghannam
+ Herbert Xu
+ Steve Capper

On Tue, Dec 23, 2014 at 3:45 PM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
> Hi,
>
> I need some information to validate arm64/crypto, do we have any
> exact/defined way to validate this.
>
> Here are my findings:
> 1. I see a dirty test module tcrypto.c where we need to give the sec
> and mode module params as inputs.
> 2. Validate through open crypto [1]
>
> Do we have any arm64 specific validations, Request for help.
>
> [1] http://sourceforge.net/projects/ocf-linux/

thanks!
-- 
Jagan.
CONFIDENTIALITY NOTICE: This e-mail message, including any attachments, 
is for the sole use of the intended recipient(s) and contains information
that is confidential and proprietary to Applied Micro Circuits Corporation or its subsidiaries. 
It is to be used solely for the purpose of furthering the parties' business relationship. 
All unauthorized review, use, disclosure or distribution is prohibited. 
If you are not the intended recipient, please contact the sender by reply e-mail 
and destroy all copies of the original message.

