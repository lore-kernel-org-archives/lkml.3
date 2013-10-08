Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3JHKpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:45:06 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:61741 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3JHKo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130926124918.GB3284@krava.brq.redhat.com>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
	<1380195398-4402-5-git-send-email-jean.pihet@linaro.org>
	<20130926124918.GB3284@krava.brq.redhat.com>
Date: Tue, 8 Oct 2013 12:44:56 +0200
Message-ID: <CAFrcx1mRg7ux1E=D1myHdNbQAry3sU89CdZ0FpfhqfxY0fPO=w@mail.gmail.com>
Subject: Re: [PATCH 4/4] perf: parse the .debug_frame section in case
 .eh_frame is not present
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26 September 2013 14:49, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Sep 26, 2013 at 01:36:38PM +0200, Jean Pihet wrote:
>> On ARM the debug info is not present in the .eh_frame sections but
>> in .debug_frame instead, in dwarf format.
>> Use libunwind to load and parse the debug info.
>>
>> Dependencies:
>>  . if present, libunwind >= 1.1 is needed to prevent a segfault when
>>    parsing the dwarf info,
>>  . libunwind needs to be configured with --enable-debug-frame. Note:
>>    --enable-debug-frame is automatically selected on ARM.
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
