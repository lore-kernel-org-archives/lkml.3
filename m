Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaI0TjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 15:39:07 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:51198 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaI0TjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 15:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyBUKXE87Vou13ni2+=Mbb1Y1n55DXp9gs_0r3e7uLtbQ@mail.gmail.com>
References: <1411582473-29184-1-git-send-email-sem@altlinux.org>
	<20140924185521.GC7996@ZenIV.linux.org.uk>
	<CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
	<20140924201813.GI7996@ZenIV.linux.org.uk>
	<20140925044601.GL7996@ZenIV.linux.org.uk>
	<20140926164442.GA26897@ZenIV.linux.org.uk>
	<20140927044555.GS7996@ZenIV.linux.org.uk>
	<CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
	<20140927183139.GT7996@ZenIV.linux.org.uk>
	<20140927191657.GU7996@ZenIV.linux.org.uk>
	<CA+55aFyBUKXE87Vou13ni2+=Mbb1Y1n55DXp9gs_0r3e7uLtbQ@mail.gmail.com>
Date: Sat, 27 Sep 2014 12:39:02 -0700
X-Google-Sender-Auth: TCRfUFfBEYe3jYJod7OjN_vbS_Y
Message-ID: <CA+55aFwGo8c6iHmb20CfkpBq12Gm+VKBpbZrd=NbSx5R4Cf3fQ@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 12:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But yeah, I guess we can/should do the trivial ugly thing for 3.17.
> Send me a proper pull-request,

.. and if it can happen before tomorrow, that would be good. I had to
give up on my wish to release 3.17 tomorrow due to the current size of
changes anyway, so there will be a rc7 (and my travel inconveniences
be damned), but I'd like this to be in that rc7. Works for you?

             Linus
