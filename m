Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab3AKQmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:42:12 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:36884 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3AKQmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:42:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130111121333.GB10751@liondog.tnic>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-11-git-send-email-yinghai@kernel.org>
	<20130111121333.GB10751@liondog.tnic>
Date: Fri, 11 Jan 2013 08:42:05 -0800
X-Google-Sender-Auth: cR5DqUBqaOFG2WcJzLs-4zhDSvw
Message-ID: <CAE9FiQUi-Fzf=HSnE+JXAkPVPDZ3YYqQr50FuUiMxv6DyDnk8A@mail.gmail.com>
Subject: Re: [PATCH v7u1 10/31] x86, 64bit: Don't set max_pfn_mapped wrong
 value early on native path
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 4:13 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 03, 2013 at 04:48:30PM -0800, Yinghai Lu wrote:
>> We are not having max_pfn_mapped set correctly until init_memory_mapping.
>>
>> so don't print it initial value for 64bit
>
> Just a minor nitpick:
>
> "So don't print its initial value for 64bit."

OK.

>
> And you don't need the newlines between each sentence.

Just want to make it more readable.

>
> Acked-by: Borislav Petkov <bp@suse.de>

Thanks, I add that.

Also, congratulation for the new job.

Yinghai
