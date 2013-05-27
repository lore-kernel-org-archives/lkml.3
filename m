Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab3E0NBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:01:19 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60816 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3E0NBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130415103639.GA25366@gmail.com>
References: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
	<20130405064654.GA25936@gmail.com>
	<20130415103639.GA25366@gmail.com>
Date: Mon, 27 May 2013 15:01:17 +0200
Message-ID: <CABPqkBQe79YaFJ_S8U67DwnP7tqPCCkYwkDC8x9c9LSY9vri9g@mail.gmail.com>
Subject: Re: Basic perf PMU support for Haswell v10
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 12:36 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Ingo Molnar <mingo@kernel.org> wrote:
>
>>
>> * Andi Kleen <andi@firstfloor.org> wrote:
>>
>> > This is based on v7 of the full Haswell PMU support,
>>
>> This series looks mostly good - I've got two requests:
>>
>>  - please rename intx -> in_tx, INTX -> IN_TX, as 'intx' is confusing
>>
>>  - please port to the latest tip:master (or perf/core), as the underlying
>>    code changed meanwhile, creating conflicts.
>
> Any update here? If not done this week then you'll possibly miss v3.10 as
> well.
>
Over a month and no update on this. This is becoming ridiculous.
This needs to go in for 3.10. Shall I do the rebase myself?
