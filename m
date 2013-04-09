Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935399Ab3DISdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:33:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48977 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933071Ab3DISdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:33:23 -0400
Message-ID: <51645EEA.4070907@ti.com>
Date: Tue, 9 Apr 2013 14:33:14 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@google.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thermal: fix frequency table lookup bugs
References: <1365465287-24530-1-git-send-email-abrestic@chromium.org> <51642BD5.4030803@ti.com> <CAL1qeaGW=m+DNbGhEzTJBDt1NNpPrVcBzzWzhk447hf2tyb2fw@mail.gmail.com> <51644E22.1050305@ti.com> <CAL1qeaEbakXL1wpURSGDJ=_FojoJ7DO4CJtj+pwPh32fufwjDQ@mail.gmail.com>
In-Reply-To: <CAL1qeaEbakXL1wpURSGDJ=_FojoJ7DO4CJtj+pwPh32fufwjDQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-04-2013 14:27, Andrew Bresticker wrote:
>> You do two things in this change on cpu_cooling.c: (1) fix the case where
>> the loop is kept running indefinitely. (2) Reserve a specific role for each
>> index in this function.
>
> So the issue is that the changes are not independent.  With just the
> fix for the infinite loop, get_cpu_frequency() is still completely
> broken because it is not interpreting the level correctly and will
> return the wrong frequency (and thus not throttling correctly, which
> is bad).  Perhaps the commit should be more general, like "fix
> handling of invalid frequency table entries"?  What do you think?

It fits better. I am OK if we improve the commit title and description, 
providing better explanation of what is the issue (you have done 
already) and how what needed to be done to fix it.

>
> Thanks,
> Andrew
>
>

