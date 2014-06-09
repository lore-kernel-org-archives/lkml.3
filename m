Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbaFIQxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:53:07 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:46522 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385AbaFIQxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <1402307589.20454.49.camel@sauron.fi.intel.com>
References: <1402307589.20454.49.camel@sauron.fi.intel.com>
Date: Mon, 9 Jun 2014 09:53:02 -0700
X-Google-Sender-Auth: sOrQAgGaajV1tiDUgt_SqIU13ms
Message-ID: <CA+55aFwr9Gtgn1JssNJFUDTsvgxoDe9BAM4XLiv5g3wDqxfS_Q@mail.gmail.com>
Subject: Re: [GIT PULL] UBIFS changes for 3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mind re-sending the explanations in their full form?

They seem to have gotten cut off, probably because some bad
cut-and-paste that missed a line or two. And the cut-and-paste error
happened when you wrote the tag signature, so the missing parts aren't
in the signed tag either, it has the same problem.

See how the description starts in the middle with "condition between
..", and then goes on to talk about "The other", when it hasn't really
said "the first" or whatever the missing part was supposed to say..

             Linus

On Mon, Jun 9, 2014 at 2:53 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
>
> ----------------------------------------------------------------
> condition between the mmap page fault path and fsync. The other
> just removes a bogus assertion from the UBIFS memory shrinker.
>
> UBIFS also started honoring the MS_SILENT mount flag, so now it won't print
> many I/O errors when user-space just tries to probe for the FS.
>
> Rest of the changes are rather minor UBI/UBIFS fixes, improvements, and
> clean-ups.
