Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3CMKQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:16:24 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37031 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab3CMKQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:16:19 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVJ8bdA9JFMkMnt6ajU2QrATpz2O6VJwGbTQecJ2UYS1Q@mail.gmail.com>
References: <20130312152226.c5965a68f57444c8652eb46a@canb.auug.org.au>
	<CAGXu5jJm2QM-s6DV3e5guQc5i-qEK52uRR6xc=ViqrvCibHEUw@mail.gmail.com>
	<CA+icZUVJ8bdA9JFMkMnt6ajU2QrATpz2O6VJwGbTQecJ2UYS1Q@mail.gmail.com>
Date: Wed, 13 Mar 2013 11:16:18 +0100
Message-ID: <CA+icZUXQ4RgPezXNQ-Zf7p5y0N6Uf176Fdmnk3NMAiKP1LtQDA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (drm-intel tree related)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Kees Cook <keescook@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:50 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Mar 12, 2013 at 6:46 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Mar 11, 2013 at 9:22 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> After merging the final tree, today's linux-next build (i386 defconfig)
>>> failed like this:
>>>
>>> drivers/built-in.o: In function `i915_min_freq_set':
>>> i915_debugfs.c:(.text+0xb1adc): undefined reference to `__udivdi3'
>>> drivers/built-in.o: In function `i915_max_freq_set':
>>> i915_debugfs.c:(.text+0xb1bac): undefined reference to `__udivdi3'
>>>
>>> Caused by commit 2389cc500686 ("drm/i915: use simple attribute in debugfs
>>> routines") from the drm-intel tree.
>>>
>>> I have reverted that commit for today.
>>
>> Ah-ha, thanks. I've sent a follow-up patch to fix this.
>>
>
> Can you please point to the patch [1] next time?
> Thanks.
>
> - Sedat -
>
> [1] https://patchwork.kernel.org/patch/2253231/
>

Hi Kees, Hi Daniel,

was the above patch merged into drm (for me it does not look like it was [1])?

Regards,
- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/?qt=author&q=Kees+Cook



>> -Kees
>>
>> --
>> Kees Cook
>> Chrome OS Security
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-next" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
