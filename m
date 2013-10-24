Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3JXQOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:14:21 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:60081 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3JXQOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:14:20 -0400
MIME-Version: 1.0
In-Reply-To: <20131024145025.GA1493@krava.redhat.com>
References: <1382108078-8807-1-git-send-email-jean.pihet@linaro.org>
	<1382108078-8807-3-git-send-email-jean.pihet@linaro.org>
	<20131024145025.GA1493@krava.redhat.com>
Date: Thu, 24 Oct 2013 18:14:19 +0200
Message-ID: <CAFrcx1=VjRbdTet2_k=w36YSgk3x+cCoNwZ1QYFpNqCymoVa0w@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM64: perf: wire up perf_regs and unwind support
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>
Cc: Arnaldo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>,
        Jean Pihet <jean.pihet@newoldbits.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri, Will,

On 24 October 2013 16:50, Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Oct 18, 2013 at 04:54:38PM +0200, Jean Pihet wrote:
>
> SNIP
>
>> +     return -EINVAL;
>> +}
>> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
>> index 75b93d7..15a69a5 100644
>> --- a/tools/perf/config/Makefile
>> +++ b/tools/perf/config/Makefile
>> @@ -29,11 +29,17 @@ ifeq ($(ARCH),x86_64)
>>    NO_PERF_REGS := 0
>>    LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
>>  endif
>> +
>>  ifeq ($(ARCH),arm)
>>    NO_PERF_REGS := 0
>>    LIBUNWIND_LIBS = -lunwind -lunwind-arm
>>  endif
>
> I dont see above 'ifeq' in acme's or in tip tree, so hunk
> below fails to apply.. what tree was this based on?
I am using 3.12-rc4. Let me rebase on the latest mainline.

Will, what do you think? I will post a rebased version asap.

> otherwise the change looks good to me
Great, thanks for reviewing!

>
> jirka

Jean
