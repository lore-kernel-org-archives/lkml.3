Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3IMRTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:19:08 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:42769 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3IMRTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130913171503.GC14224@mudshark.cambridge.arm.com>
References: <1379092121-5981-1-git-send-email-jean.pihet@linaro.org>
	<20130913171503.GC14224@mudshark.cambridge.arm.com>
Date: Fri, 13 Sep 2013 19:19:06 +0200
Message-ID: <CAFrcx1nE8GUa59-5TsJxH9+deBLB-vuX2R+b8dxtgFvOX8FC7w@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Check libunwind for availability of dwarf
 parsing feature
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 13 September 2013 19:15, Will Deacon <will.deacon@arm.com> wrote:
> Hi Jean,
>
> On Fri, Sep 13, 2013 at 06:08:41PM +0100, Jean Pihet wrote:
>> The newly added dwarf unwinding feature [1] requires:
>> . a recent version (>= 1.1) of libunwind,
>> . libunwind to be configured with --enable-debug-frame.
>>
>> [1] http://www.spinics.net/lists/kernel/msg1598951.html
>>
>> Add the corresponding API test in the feature check list.
>
> Any reason not to merge this in with the third patch in original series? I
> don't think it's been picked up by anybody yet, so it would make sense to
> repost with this fixup after the merge window.
Yes you are right
Will repost with this patch folded into the third patch, or as a
fourth patch. Any preference?

Thx,
Jean

>
> Will
