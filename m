Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab3ANUBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:01:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33886 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3ANUBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:01:30 -0500
MIME-Version: 1.0
In-Reply-To: <20130114184616.GB2015@liondog.tnic>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-24-git-send-email-yinghai@kernel.org>
	<20130114112045.GF1228@liondog.tnic>
	<CAE9FiQUVkrv3jcCZnrg3=7pXyyfd9d+MJGDqU-dF_+YtB+2-ww@mail.gmail.com>
	<CAE9FiQWPbRRGkycs_oocNcHB+bEcdkqxX9zHfJVmwq_hKgKBOA@mail.gmail.com>
	<20130114184616.GB2015@liondog.tnic>
Date: Mon, 14 Jan 2013 12:01:29 -0800
X-Google-Sender-Auth: xysc5vSHXXoTSVJsw0ZtF3bZ8NQ
Message-ID: <CAE9FiQVOrFRpuPGMxnP-w9KLaxXfU7S22Q-cgM__=iB60GuZEQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 23/31] x86, boot: update comments about entries for
 64bit image
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:46 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jan 14, 2013 at 10:37:39AM -0800, Yinghai Lu wrote:
>> also I fix some errors that you mentioned, but not all of them because
>> I copied 32bit portion to 64bit and modified it.
>>
>> So you may submit patch to fix 32bit and 64bit at the same time if you
>> like.
>
> Sure, if they're old typos/errors. If they're new typos/errors
> introduced by you, then you know that we don't commit half-baked
> patches, right?

no, we should not.

some times I could tell your understanding is right or not.

other cases, i just don't know if your changes is right or original 32
bit sentence
is right.

So later, you or maybe hpa would like to change them at the same time.

Yinghai
