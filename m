Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3DWPlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:41:06 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:45224 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3DWPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:41:04 -0400
MIME-Version: 1.0
In-Reply-To: <5176A5F7.6000609@zytor.com>
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com>
	<CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com>
	<201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp>
	<201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
	<5176A5F7.6000609@zytor.com>
Date: Tue, 23 Apr 2013 18:41:01 +0300
Message-ID: <CAHp75Vc-oKmzYRC-NyvJGDvPVFPZv_7D66bG5KXppJvNS658_g@mail.gmail.com>
Subject: Re: [PATCH] x86_32: Fix module version table mismatch.
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        arjan <arjan@infradead.org>, "james.hogan" <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 6:17 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/23/2013 05:40 AM, Tetsuo Handa wrote:
>>
>> -#define memcmp __builtin_memcmp
>> +int memcmp(const void *cs, const void *ct, size_t count);
>>
>
> Yuck.  I really don't like this option unless it truly can't be
> avoided... it might be a fix for 3.9/stable but a better way to do this
> would be much more appreciated.

What about my proposal to supply parameters for __builtin_memcmp in
memcmp macro.

--
With Best Regards,
Andy Shevchenko
