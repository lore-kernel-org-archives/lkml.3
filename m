Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3CUVrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:47:09 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55448 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3CUVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130321214118.GA25517@redhat.com>
References: <20130321190653.GA15479@redhat.com>
	<20130321192935.GY21522@ZenIV.linux.org.uk>
	<CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
	<20130321202635.GA16406@redhat.com>
	<CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
	<20130321203639.GC16406@redhat.com>
	<20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
	<CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
	<20130321212617.GA21522@ZenIV.linux.org.uk>
	<20130321214118.GA25517@redhat.com>
Date: Thu, 21 Mar 2013 14:47:06 -0700
X-Google-Sender-Auth: -ke_pJ8xj7bzbOIKR52zsZyLUTI
Message-ID: <CA+55aFyKCswjX2Spg3UY8t9Uj2KwD-3Aga9epBUPR0cWnHfNqA@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 2:41 PM, Dave Jones <davej@redhat.com> wrote:
>
> How do I go from the dentry in p1 to the path d_absolute_path expects ?

You don't. Use dentry_path() instead. It will also end up giving you
the information about whether the dentry is unlinked or not.

         Linus
