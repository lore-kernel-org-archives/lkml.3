Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbaEEOxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:53:30 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:40590 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448AbaEEOx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:53:28 -0400
MIME-Version: 1.0
In-Reply-To: <536794CB.8060903@linuxfoundation.org>
References: <CA+55aFz6Sxjy9jdai=TkeB2Rbpu0ydL4-YW4j-S-9oixDu5oZw@mail.gmail.com>
	<CA+5PVA4Wt19ByW5c__jJWFFz0_0uvnbQeRn13w6S43TMZJt8YA@mail.gmail.com>
	<536794CB.8060903@linuxfoundation.org>
Date: Mon, 5 May 2014 07:53:27 -0700
X-Google-Sender-Auth: 1hO4ipcOgefi_pYK1UV8Brp4NW0
Message-ID: <CA+55aFw9H2bym1JUPbaa9xP7jN9Q=hawyXS2gPEv+mPPWmt6BQ@mail.gmail.com>
Subject: Re: Linux 3.15-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 6:40 AM, Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> Looks like it got placed into /v3.x/ instead of /testing/. I'll move it
> into /testing/ shortly, which should kick off the site update (the
> script only looks for -rc kernels in /testing/).

Thanks Konstantin. My bad.

My release automation is almost entirely scripted, but the "where does
it go" part is still me telling the scripts, and I screwed that up. I
guess I should just add that too to the scripting..

             Linus
