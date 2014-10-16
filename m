Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaJPMpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:45:10 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:48869 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJPMpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:45:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAB61YWPUjOFx8W_K923uz1GYZsLvVq+cH=k-fguzndqZhsWUww@mail.gmail.com>
References: <1413454804-19370-1-git-send-email-jgeboski@gmail.com>
 <CAKohpokvx5G5JU_KYePOecRfAgXrOrOt__iagMcHQ2iy05gZLQ@mail.gmail.com> <CAB61YWPUjOFx8W_K923uz1GYZsLvVq+cH=k-fguzndqZhsWUww@mail.gmail.com>
From: James Geboski <jgeboski@gmail.com>
Date: Thu, 16 Oct 2014 08:44:45 -0400
Message-ID: <CAB61YWNi-wNHK0M7QAEPgc9UHUEMX=DuW7CYgxjmrBogKEiOYA@mail.gmail.com>
Subject: Fwd: [PATCH] cpufreq: allow powersave governor as the default without
 expert mode
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 6:27 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 16 October 2014 15:50, James Geboski <jgeboski@gmail.com> wrote:
>> The intel_pstate driver only supports the performance and the powersave
>> governors. With the performance governor ensuring the highest possible
>> performance settings, userspace tools fail to make any lasting changes.
>> In order to allow userspace tools to make modifications to the settings,
>> the powersave governor must be in use. This makes having the powersave
>> governor as the default convenient for systems where the intel_pstate
>> driver is being employed. Having to enable expert mode in the kernel
>> configuration is just a headache for such a trivial task.
>>
>> This patch applies to all kernel versions 2.6.38 or greater after the
>> migration from CONFIG_EMBEDDED to CONFIG_EXPERT (6a108a14fa35). Most
>> importantly, this applies to kernel versions 3.9 or greater when the
>> intel_pstate driver was introduced.
>>
>> Signed-off-by: James Geboski <jgeboski@gmail.com>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/cpufreq/Kconfig | 1 -
>>  1 file changed, 1 deletion(-)
>
> Why did you resent it? Without any information at all about what has changed?

I added your Acked-by line to the patch message. However, I am apparently
incompetent with git-send-email. I have replied to the original thread,
please discard this thread. My apologizes for the excessive noise.
