Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaI0Tzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 15:55:49 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47279 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaI0Tzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 15:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140927194925.GW7996@ZenIV.linux.org.uk>
References: <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
	<20140924201813.GI7996@ZenIV.linux.org.uk>
	<20140925044601.GL7996@ZenIV.linux.org.uk>
	<20140926164442.GA26897@ZenIV.linux.org.uk>
	<20140927044555.GS7996@ZenIV.linux.org.uk>
	<CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
	<20140927183139.GT7996@ZenIV.linux.org.uk>
	<20140927191657.GU7996@ZenIV.linux.org.uk>
	<CA+55aFyBUKXE87Vou13ni2+=Mbb1Y1n55DXp9gs_0r3e7uLtbQ@mail.gmail.com>
	<CA+55aFwGo8c6iHmb20CfkpBq12Gm+VKBpbZrd=NbSx5R4Cf3fQ@mail.gmail.com>
	<20140927194925.GW7996@ZenIV.linux.org.uk>
Date: Sat, 27 Sep 2014 12:55:45 -0700
X-Google-Sender-Auth: em3bPvEa_4EILjIgIcNkiTR3R5k
Message-ID: <CA+55aFzUVL9H7zwbVjhBRuJekaOCiYxJCb4V3RyuzjXzykvs+g@mail.gmail.com>
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

On Sat, Sep 27, 2014 at 12:49 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Fine by me.  How about that s-o-b?  Right now it's

Sure, add my sign-off too. Not that I feel I even need the credit, so
you could just have done it as yourself. But I'll take it, so..

  Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Thanks,
        Linus
