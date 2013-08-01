Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab3HARpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:45:20 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:62295 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab3HARpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:45:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130801153727.GA3870@logfs.org>
References: <20130731174335.006a58f9@annuminas.surriel.com>
	<CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
	<51F98CAB.80100@redhat.com>
	<CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com>
	<51F99218.4060104@redhat.com>
	<CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com>
	<51F999DE.7080200@redhat.com>
	<20130801153727.GA3870@logfs.org>
Date: Thu, 1 Aug 2013 10:45:15 -0700
X-Google-Sender-Auth: oWBjMPIaImpUcAbypYXb2b3vcIE
Message-ID: <CA+55aFx+_35OosBzwSmwAiw1xuRw5=i4vaSpjxuEc5xqvLZ_Rg@mail.gmail.com>
Subject: Re: [PATCH] sched,x86: optimize switch_mm for multi-threaded workloads
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
Cc: Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 8:37 AM, Jörn Engel <joern@logfs.org> wrote:
>
> Looks like two of Linus' mails didn't make it to vger.kernel.org.
> They are missing from my inbox and seem to be missing from lkml.org as
> well.  I only know noticed them because Rik seemingly replied to
> himself while quoting Linus.

It's normal. I occasionally write quick replies while on my phone, and
the f*cking android gmail app cannot do plain-text mode. There are
open bug tickets about it:

   https://code.google.com/p/android/issues/detail?id=8712

and I've talked in private to my google contacts too, but some
ass-wipe inside the android team thinks that html-only mail is the
right thing to do.

The sad part is that there is absolutely no *technical* reason for it,
since the gmail android app actually generates a multipart/alternative
email where the first part is perfectly fine text, properly wrapped
and everything. So the code to generate the email in proper format is
actually there, it's just that there is no setting to say "don't
generate the other parts". It's literally one added setting, and
probably a few lines of code to test it and not generate the html
part.

So there's some internal politics going on, probably one or two
internal people who are just ass-hats and are lying to their managers
about how hard it is to do. Don't ask me why. Some people just want to
watch the world burn.

And no, don't tell me about the other mailers. I've tried many of
them. They tend to be badly integrated or have their own crazy issues.
I'm not willing to read email over imap any more. The one big feature
of gmail is how you can search for things sanely on the server side,
and despite the imap server-side searching technically being a
feature, I've never met any server and MUA that does it reasonably.
Gmail does, but sadly the android app has this one big glaring fault.

Which is sad, because in other ways the android gmail app is actually
quite good these days (that didn't use to be true, but they've fixed
much bigger problems over the years).

Feel free to pester the android people, *especially* if you know
somebody inside the gmail app team. Call them out on the bullshit if
somebody says "that's hard". Sadly, the features they *have* added
seem to be about things big companies asked for, not trivial technical
improvements.

                      Linus
