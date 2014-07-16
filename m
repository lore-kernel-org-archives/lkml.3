Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaGPXDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:03:51 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:44643 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaGPXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:03:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyERejiNtDfw2QiSFQT33jPK5WVhLSeCuOAAyZ0pBOJFQ@mail.gmail.com>
References: <1405541983-6210-1-git-send-email-jim.epost@gmail.com>
	<CAFLxGvyERejiNtDfw2QiSFQT33jPK5WVhLSeCuOAAyZ0pBOJFQ@mail.gmail.com>
Date: Wed, 16 Jul 2014 16:03:47 -0700
Message-ID: <CA+r1ZhhexC=GTmcoUf=W_eA2dLkt5whe6ya9UMWbhHTUu3RD6w@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: coreteam@netfilter.org is moderated
From: Jim Davis <jim.epost@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        kdalec@blackhole.kfki.hu, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/14, Richard Weinberger <richard.weinberger@gmail.com> wrote:
> On Wed, Jul 16, 2014 at 10:19 PM, Jim Davis <jim.epost@gmail.com> wrote:
>> The coreteam@netfilter.org mailing list is moderated for non-subscribers.
>>
>> Signed-off-by: Jim Davis <jim.epost@gmail.com>
>> ---
>>  MAINTAINERS | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 9ced7318776d..7c9287acdb98 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6118,7 +6118,7 @@ M:        Pablo Neira Ayuso <pablo@netfilter.org>
>>  M:     Patrick McHardy <kaber@trash.net>
>>  M:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>>  L:     netfilter-devel@vger.kernel.org
>> -L:     coreteam@netfilter.org
>> +M:     coreteam@netfilter.org (moderated for non-subscribers)
>
> Why M?

...because I goofed.  Looks like 'L' (with moderated notation) would
be the right option.
