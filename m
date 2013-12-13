Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3LMXzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:55:03 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33474 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3LMXzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:55:00 -0500
Message-ID: <52AB9E51.2020807@linaro.org>
Date: Fri, 13 Dec 2013 15:54:57 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH 001/115] gpu: ion: Add ION Memory Manager
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org> <1386973529-4884-2-git-send-email-john.stultz@linaro.org> <20131213235028.GA4919@kroah.com>
In-Reply-To: <20131213235028.GA4919@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 03:50 PM, Greg KH wrote:
> On Fri, Dec 13, 2013 at 02:23:35PM -0800, John Stultz wrote:
>> From: Rebecca Schultz Zavin <rebecca@android.com>
>>
>> Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
>> [jstultz: Squished in Colin Cross' move to staging change]
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>>  drivers/staging/android/Kconfig                 |    2 +
>>  drivers/staging/android/Makefile                |    2 +
> This patch breaks the build if this option is enabled.
>
> I suggest only adding the driver to the build _after_ it can be built,
> for obvious reasons :)

Right. Until recently it really only builds on ARM. There's a patch
which adds that dependency (and then later removes it once other fixes
land), but its later in the patch series.

Apologies.

> Other than this "minor" thing, I have no objection to these patches at
> all.  Can you redo this patch to fix this up, and maybe send another
> patch adding it to the build and let me know at what point in the series
> it should be applied?
I'll squish that config dependency down to the first patch and go
through verifying it builds.

> Also, I only received 92 of these patches, not all 115, are they stuck
> somewhere in a mail queue?
Maybe? I hope! I've never played GregKH and sent such a large patchset
before!

thanks
-john



