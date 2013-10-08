Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3JHKog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:44:36 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:61814 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3JHKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:44:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130926124829.GA3284@krava.brq.redhat.com>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
	<1380195398-4402-4-git-send-email-jean.pihet@linaro.org>
	<20130926124829.GA3284@krava.brq.redhat.com>
Date: Tue, 8 Oct 2013 12:44:32 +0200
Message-ID: <CAFrcx1nDe6mhxEuU4ROJGOmGFaYtVnnhXYirkmhRb1NEecNhtw@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf tools: Check libunwind for availability of dwarf
 parsing feature
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        ".Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26 September 2013 14:48, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Sep 26, 2013 at 01:36:37PM +0200, Jean Pihet wrote:
>> The newly added dwarf unwinding feature [1] requires:
>> . a recent version (>= 1.1) of libunwind,
>> . libunwind to be configured with --enable-debug-frame.
>>
>> [1] http://www.spinics.net/lists/kernel/msg1598951.html
>>
>> Add the corresponding API tests in the feature check list.
>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
>
> thanks,
> jirka

Thanks for the ack!

Is it possible to get an ack from the perf core maintainers?
Also, is the patch going in Will's tree?

Regards,
Jean
