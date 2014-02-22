Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaBVKde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 05:33:34 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36133 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaBVKda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 05:33:30 -0500
Subject: Re: [PATCH v5 2/5] ACPI / processor_core: Rework _PDC related stuff to make it more arch-independent
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <1408521.4TEdKhuRp5@vostro.rjw.lan>
Date: Sat, 22 Feb 2014 10:33:25 +0000
Cc: Hanjun Guo <hanjun.guo@linaro.org>, Lan Tianyu <tianyu.lan@intel.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F980FA86-6705-4A71-956C-EA2DBD787199@arm.com>
References: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org> <3459962.GkY99aHQbc@vostro.rjw.lan> <20140221182424.GA5751@arm.com> <1408521.4TEdKhuRp5@vostro.rjw.lan>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Feb 2014, at 23:35, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, February 21, 2014 06:24:24 PM Catalin Marinas wrote:
>> On Wed, Feb 19, 2014 at 01:50:22AM +0100, Rafael J. Wysocki wrote:
>>> On Wednesday, February 19, 2014 12:23:55 AM Hanjun Guo wrote:
>>>> _PDC related stuff in processor_core.c is little bit X86/IA64 dependent,
>>>> rework the code to make it more arch-independent, no functional change
>>>> in this patch.
>>>> 
>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>>> 
>>> I've queued up patches [1,3-5/5] from this series for 3.15 (modulo changelog
>>> modifications), but this one should be CCed to the x86 and ia64 maintainers.
>> 
>> Thanks for taking these patches. I would however hold onto patch 3/5 as
>> this is still under discussion. Basically for patches specific to ARM
>> ACPI I would really like to see more acks before being merged as that's
>> a new thing for us.
> 
> OK, I'll drop [3/5] for now, then.

Thanks (it’s only temporary ;)).

> I'm wondering, though, whose ACKs I should be waiting for before applying those
> patches?

Good question ;). In this particular case, there is an ongoing
discussion between Hanjun and Sudeep. While there isn’t anything
major, I would like to see some agreement and potentially an Ack from
the other party involved in the discussion (Sudeep).

There are other patches that are not specific to ARM, so it’s
really your decision. As for the general ARM(64) ACPI case, I don’t
think we have anyone in charge with deciding what’s correct or not
(BTW, who are the people active both in the _ARM_ Linux kernel community
and the ACPI standardisation forum?).

In the mean-time, I would like to see at least an ack from the arm-soc
team (Arnd and Olof) or them collecting those ARM-specific patches and
sending pull request to you. My biggest worry is how the ACPI standard
is interpreted by vendors and how (non-standard) features get into the 
Linux kernel.

Anyway, I’ll meet the Linaro guys in a week time and we’ll agree on
a way forward.

Thanks,

Catalin