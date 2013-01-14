Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab3ANW2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:28:43 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43180 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524Ab3ANW2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:28:41 -0500
MIME-Version: 1.0
In-Reply-To: <50F46DAC.6040501@zytor.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-26-git-send-email-yinghai@kernel.org>
	<50F46DAC.6040501@zytor.com>
Date: Mon, 14 Jan 2013 14:28:40 -0800
X-Google-Sender-Auth: gPoxhN0Xczi4MzfPjMl2QHRa8QI
Message-ID: <CAE9FiQXrKRx4rNWvMHL8No2hWQBNd7bQFqn-FZWtF1ybdPJ60Q@mail.gmail.com>
Subject: Re: [PATCH v7u1 25/31] memblock: add memblock_mem_size()
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 12:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/03/2013 04:48 PM, Yinghai Lu wrote:
>>
>> -     mapped_size = get_mem_size(max_pfn_mapped);
>> +     mapped_size = (u64)memblock_mem_size(max_pfn_mapped);
>
> This cast is completely unnecessary.

ok, dropped that cast.
