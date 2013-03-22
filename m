Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3CVAXC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:23:02 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:61261 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3CVAXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:23:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130322001257.GH21522@ZenIV.linux.org.uk>
References: <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
	<20130321203639.GC16406@redhat.com>
	<20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
	<CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
	<20130321221256.GA30620@redhat.com>
	<CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
	<20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
	<CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
	<20130322001257.GH21522@ZenIV.linux.org.uk>
Date: Thu, 21 Mar 2013 17:22:59 -0700
X-Google-Sender-Auth: OFup8_TwhCKi4uirZ3ALQ0WkRp0
Message-ID: <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 5:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> What we should do, IMO, is to turn /proc/<pid>/net into a honest symlink -
> to ../nets/<netns ID>/net.  Hell, might even make it a magical symlink
> instead...

Ok, having seen the error of my ways, I'm starting to agree with you..
 How painful would that be? Especially since we'd need to backport
it..

              Linus
