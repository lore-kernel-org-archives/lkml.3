Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab3D2Vnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:43:39 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:38521 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3D2VnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:43:00 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzEwRUWVQ8x1+f=6R_9+JO_Rmg=u2E1k_6jLuQEAorgtQ@mail.gmail.com>
References: <20130429195100.202681236@goodmis.org>
	<CA+55aFzEwRUWVQ8x1+f=6R_9+JO_Rmg=u2E1k_6jLuQEAorgtQ@mail.gmail.com>
Date: Mon, 29 Apr 2013 14:42:59 -0700
X-Google-Sender-Auth: ea9G_nhbSmJP6SAa1YUHj5MLvVA
Message-ID: <CA+55aFzSfRv26E3UF1a8jwQK+vHSru-YTg8ADefZxOKZNnn6fA@mail.gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] localmodconfig: Fix missing depends of
 config files included in if statements
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 2:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> There's just too much confusion here for me to touch anything at all,
> so please fix things up.

Oh, and you might as well check that I resolved the conflicts in the
trace pull correctly while you're at it. They looked pretty obvious,
and it compiles for me, but ..

              Linus
