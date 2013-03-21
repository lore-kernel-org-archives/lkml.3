Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab3CUV5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:57:33 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:38182 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab3CUV5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:57:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130321215502.GC21522@ZenIV.linux.org.uk>
References: <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
	<20130321202635.GA16406@redhat.com>
	<CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
	<20130321203639.GC16406@redhat.com>
	<20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
	<CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
	<20130321212617.GA21522@ZenIV.linux.org.uk>
	<20130321214118.GA25517@redhat.com>
	<CA+55aFyKCswjX2Spg3UY8t9Uj2KwD-3Aga9epBUPR0cWnHfNqA@mail.gmail.com>
	<20130321215502.GC21522@ZenIV.linux.org.uk>
Date: Thu, 21 Mar 2013 14:57:29 -0700
X-Google-Sender-Auth: bFCX9Zte-h252g3IgAL295u9dDI
Message-ID: <CA+55aFzK_OBwhuBw1Oap6Z-Q4+D3NZipZXBn50JuRvcYVz60+w@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 2:55 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Mar 21, 2013 at 02:47:06PM -0700, Linus Torvalds wrote:
>
>> It will also end up giving you
>> the information about whether the dentry is unlinked or not.
>
> You also want to know if p2 is unlinked, though (and yes, it's dentry_path(),
> of course - apologies for the braino).

Just do dentry_path on both p1 and p2. You'll have to have two
different buffers for them, of course.

          Linus
