Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3JFUmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:42:09 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:53239 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3JFUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131006004331.GY13318@ZenIV.linux.org.uk>
References: <20131006004331.GY13318@ZenIV.linux.org.uk>
Date: Sun, 6 Oct 2013 13:42:05 -0700
X-Google-Sender-Auth: -JziXidn2UlU5b0JxZfDZOiTB_U
Message-ID: <CA+55aFy8TAeeTA0YVRs8w=MjUC0idvNqB+9BcLWVLPw_LEQajg@mail.gmail.com>
Subject: Re: [RFC] apparently broken RLIMIT_CORE
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 5, 2013 at 5:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         In other words, the size of notes section is ignored for
> RLIMIT_CORE purposes.  Is that intentional?

I doubt it is intentional, but I also cannot really feel that we care
deeply. Afaik we don't really honor the size limit exactly anyway, ie
we tend to check only at page boundaries etc. So do we really care?

               Linus
