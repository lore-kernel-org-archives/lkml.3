Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3CKFDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:03:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30512 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3CKFDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:03:23 -0400
X-Spam-Score: -100.8
Message-ID: <513D6583.8040506@asianux.com>
Date: Mon, 11 Mar 2013 13:02:59 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linus.walleij@linaro.org, marc.zyngier@arm.com, shawn.guo@linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM:kernel: beautify code, using 'static const' instead
 of 'const static'
References: <513BE8FA.6080304@asianux.com> <513D32E3.1080101@gmail.com>
In-Reply-To: <513D32E3.1080101@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月11日 09:26, Rob Herring 写道:
> On 03/09/2013 07:59 PM, Chen Gang wrote:
>> > 
>> >   better using 'static const' instead of 'const static'
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  arch/arm/kernel/smp_twd.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> > 
>> > diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
>> > index 3f25650..ef3e499 100644
>> > --- a/arch/arm/kernel/smp_twd.c
>> > +++ b/arch/arm/kernel/smp_twd.c
>> > @@ -362,7 +362,7 @@ int __init twd_local_timer_register(struct twd_local_timer *tlt)
>> >  }
>> >  
>> >  #ifdef CONFIG_OF
>> > -const static struct of_device_id twd_of_match[] __initconst = {
>> > +static const struct of_device_id twd_of_match[] __initconst = {
> This will go away with conversion to use CLKSRC_OF.

  excuse me, I am not quite familiar with ARM, so I do not quite
understand what you said.

  could you describe it with more details ?
  and how about this patch ?
    a. do not need this patch.
    b. or this patch need improving.
    c. or this patch is ok, can be applied.

  thanks.

-- 
Chen Gang

Asianux Corporation
