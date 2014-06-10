Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaFJXeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:34:00 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:38285 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaFJXd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:33:58 -0400
MIME-Version: 1.0
In-Reply-To: <5397952E.9040008@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
 <1402441994-16780-4-git-send-email-hpa@zytor.com> <CALCETrUrdvvTc+qt61nQ1iRW4qpyDfMSzqnLKFMUsx7P=XvAfA@mail.gmail.com>
 <5397952E.9040008@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 10 Jun 2014 16:33:37 -0700
Message-ID: <CALCETrUvN1kYB=Z+wmPfbJawWSHb-r5NhmYLV1ZTxOWmHkanHw@mail.gmail.com>
Subject: Re: [PATCH RFC 03/10] tools: Add le_direct/be_direct methods for
 unaligned access
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 4:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/10/2014 04:25 PM, Andy Lutomirski wrote:
>> On Tue, Jun 10, 2014 at 4:13 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> For architectures which handle unaligned references transparently.
>>
>> Shouldn't these depend on host endianness?
>>
>
> See further down the series for how these end up being invoked.
>

Ah, sneaky.

Would it make sense to put a comment in this file (and similar files)
indicating that they must only be included on architectures of the
appropriate endianness?

--Andy

>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
