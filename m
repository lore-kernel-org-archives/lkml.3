Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3JAUbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:31:04 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38978 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3JAUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:31:00 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAJfpegvddcZMFLMOikx5vKa8v_o5b+QjupKZNRTj8uGuOLiHtA@mail.gmail.com>
References: <CA+icZUUOfFdd34CZfGpX+_ezuaPyeakZSGGvfmw8K1cguUbmxg@mail.gmail.com>
	<CA+55aFzuZp094CB-FG2Ku32m3ZR5DC6FKGSfnLVdy3w9Aju2Bg@mail.gmail.com>
	<CAJfpegvddcZMFLMOikx5vKa8v_o5b+QjupKZNRTj8uGuOLiHtA@mail.gmail.com>
Date: Tue, 1 Oct 2013 22:30:58 +0200
Message-ID: <CA+icZUXZt5ZvodGTcdLnh0LMmL8hb43b5Dxb7Ce4f0ZOtLNUKg@mail.gmail.com>
Subject: Re: fuse-3.12-fixes?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Maxim Patlasov <MPatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 5:21 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Sep 30, 2013 at 5:13 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, Sep 30, 2013 at 12:20 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>
>>> any reasons why these fuse-3.12-fixes did not went into -rc3?
>>
>> Perhaps because they were never sent to me?
>>
>> Searching my email archives I see that a pull request went to Al and
>> the mailing lists, but not actually to me. I do have a pending pull
>> request from Al (which came in after -rc3) but that doesn't contain
>> them either. And the "for-linus" branch implies that perhaps somebody
>> _iindended_ to send them to me, but somehow missed.
>
> Mea culpa.  I sent it to Al, but didn't create a for_al branch for it,
> and Al didn't pull.  I'll send a new pull request after testing the
> fuse_dentry_revalidate fixes.
>

Hm, I see some updates in the for-linus GIT branch, but no for-al...

- Sedat -
