Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab3BXC4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 21:56:06 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:33733 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab3BXC4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 21:56:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130220225214.GJ4503@ZenIV.linux.org.uk>
References: <20130220225214.GJ4503@ZenIV.linux.org.uk>
Date: Sat, 23 Feb 2013 18:56:02 -0800
X-Google-Sender-Auth: RKv76VBkSXztbJXXG3cg1TjKoAI
Message-ID: <CA+55aFwx-O4Q=1gKgv=cyG8ObzUyPVh9Ctmuh-DX_DE9rumU5g@mail.gmail.com>
Subject: Re: [git pull] signal.git
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 2:52 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> * a bunch of signal-related syscalls (both native and compat) unified.

Ok, in the meantime I had merged the parisc and powerpc trees, which
had their own fixes in this area: powerpc added the transactional
memory support for power8 (which impacted signal save/restore), and
parisc had some fixes to the routines you then removed in favor of
generic ones.

I fixed up the conflicts, and they didn't look that bad, but I could
easily have messed something up, so people - please double-check the
end result.

             Linus
