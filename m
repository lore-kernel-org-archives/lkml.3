Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaD3C4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:56:19 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:33514 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaD3C4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:56:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140430023142.GN18016@ZenIV.linux.org.uk>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
	<CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
	<20140429181610.GJ18016@ZenIV.linux.org.uk>
	<20140429191015.GK18016@ZenIV.linux.org.uk>
	<20140429211851.GA32204@dastard>
	<20140429214842.GL18016@ZenIV.linux.org.uk>
	<CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
	<20140429232013.GM18016@ZenIV.linux.org.uk>
	<20140430023142.GN18016@ZenIV.linux.org.uk>
Date: Tue, 29 Apr 2014 19:56:13 -0700
X-Google-Sender-Auth: W5vYlOIwYfclTQYKtkK4Ax1aSuE
Message-ID: <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 7:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, aggregate diff follows, more readable splitup (3 commits) attached.
> It seems to survive beating here; testing, review and comments are
> welcome.

Miklos, did you have some particular load that triggered this, or was
it just some reports? It would be really good to get this patch some
stress-testing.

I like how the patch removes more lines than it adds, but apart from
that it's hard to read the patch (even the split-out ones) and say
anything more about it. I think this needs a *lot* of testing.

                 Linus
