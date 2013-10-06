Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3JFVHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:07:53 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:42136 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3JFVHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:07:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy8TAeeTA0YVRs8w=MjUC0idvNqB+9BcLWVLPw_LEQajg@mail.gmail.com>
References: <20131006004331.GY13318@ZenIV.linux.org.uk> <CA+55aFy8TAeeTA0YVRs8w=MjUC0idvNqB+9BcLWVLPw_LEQajg@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sun, 6 Oct 2013 17:07:30 -0400
Message-ID: <CAOPLpQfadzGT0OqGmJ7pLf9-b5PQ7ikHVpHMsgs-pJ4DnFCcXA@mail.gmail.com>
Subject: Re: [RFC] apparently broken RLIMIT_CORE
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 6, 2013 at 4:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I doubt it is intentional, but I also cannot really feel that we care
> deeply. Afaik we don't really honor the size limit exactly anyway, ie
> we tend to check only at page boundaries etc. So do we really care?

I could imagine in the case Al brought up (a pipe as core file filter)
we might want to have some assurance the limits are not breached.  If
it doesn't cost that much I'd say implement it precisely.
