Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3I3PNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:13:30 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:35858 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3I3PN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUUOfFdd34CZfGpX+_ezuaPyeakZSGGvfmw8K1cguUbmxg@mail.gmail.com>
References: <CA+icZUUOfFdd34CZfGpX+_ezuaPyeakZSGGvfmw8K1cguUbmxg@mail.gmail.com>
Date: Mon, 30 Sep 2013 08:13:25 -0700
X-Google-Sender-Auth: BWDl74FAfqAsr1ELT73x5omdG0s
Message-ID: <CA+55aFzuZp094CB-FG2Ku32m3ZR5DC6FKGSfnLVdy3w9Aju2Bg@mail.gmail.com>
Subject: Re: fuse-3.12-fixes?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Maxim Patlasov <MPatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 12:20 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> any reasons why these fuse-3.12-fixes did not went into -rc3?

Perhaps because they were never sent to me?

Searching my email archives I see that a pull request went to Al and
the mailing lists, but not actually to me. I do have a pending pull
request from Al (which came in after -rc3) but that doesn't contain
them either. And the "for-linus" branch implies that perhaps somebody
_iindended_ to send them to me, but somehow missed.

               Linus
