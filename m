Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3I3PVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:21:14 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34953 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3I3PVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:21:09 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <CA+55aFzuZp094CB-FG2Ku32m3ZR5DC6FKGSfnLVdy3w9Aju2Bg@mail.gmail.com>
References: <CA+icZUUOfFdd34CZfGpX+_ezuaPyeakZSGGvfmw8K1cguUbmxg@mail.gmail.com>
	<CA+55aFzuZp094CB-FG2Ku32m3ZR5DC6FKGSfnLVdy3w9Aju2Bg@mail.gmail.com>
Date: Mon, 30 Sep 2013 17:21:07 +0200
Message-ID: <CAJfpegvddcZMFLMOikx5vKa8v_o5b+QjupKZNRTj8uGuOLiHtA@mail.gmail.com>
Subject: Re: fuse-3.12-fixes?
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Maxim Patlasov <MPatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 5:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Sep 30, 2013 at 12:20 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> any reasons why these fuse-3.12-fixes did not went into -rc3?
>
> Perhaps because they were never sent to me?
>
> Searching my email archives I see that a pull request went to Al and
> the mailing lists, but not actually to me. I do have a pending pull
> request from Al (which came in after -rc3) but that doesn't contain
> them either. And the "for-linus" branch implies that perhaps somebody
> _iindended_ to send them to me, but somehow missed.

Mea culpa.  I sent it to Al, but didn't create a for_al branch for it,
and Al didn't pull.  I'll send a new pull request after testing the
fuse_dentry_revalidate fixes.

Thanks,
Miklos
