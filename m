Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaI1PCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 11:02:37 -0400
Received: from pegasus3.altlinux.org ([194.107.17.103]:39112 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaI1PCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 11:02:35 -0400
Date: Sun, 28 Sep 2014 19:01:58 +0400
From: Mikhail Efremov <sem@altlinux.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames
 unconditionally.
Message-ID: <20140928190158.796d4c18@sem-notebook>
In-Reply-To: <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
	<20140924185521.GC7996@ZenIV.linux.org.uk>
	<CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
	<20140924201813.GI7996@ZenIV.linux.org.uk>
	<20140925044601.GL7996@ZenIV.linux.org.uk>
	<20140926164442.GA26897@ZenIV.linux.org.uk>
	<20140927044555.GS7996@ZenIV.linux.org.uk>
	<CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.21; x86_64-alt-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Sep 2014 10:56:57 -0700 Linus Torvalds wrote:
> (And Mikhail - I'm not ragging on you, even if I'm ragging on the
> patch. I understand why you did it the way you did, and it makes sense
> exactly in the "let's reinstate old hackery" model. I just think we
> can and should do better than that, now that the "exchange" vs "move
> over" semantics are so explicit).

Well, I can't argue with the fact that this patch is ugly, especially
after all this discussion.
I just hope that the right solution will be implemented soon and this
ugly hack will be dropped.

> Al (or Mikhail) - willing to do that extra cleanup? Please?

I'll definetly take a look at this, but I doubt that I will be able to
implement the right solution soon. Actually this is the first time when
I look at the kernel code so deeply.
I hope that someone with much more knowledge of the kernel code than my
own (Al or Miklos may be) will do that.

-- 
WBR, Mikhail Efremov
