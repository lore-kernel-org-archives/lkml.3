Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3EIUMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:12:45 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:49815 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3EIUMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:12:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130509192655.GG25399@ZenIV.linux.org.uk>
References: <20130509192655.GG25399@ZenIV.linux.org.uk>
Date: Thu, 9 May 2013 13:12:43 -0700
X-Google-Sender-Auth: QNJLp-M1YQoVsCbtGzSAN_C1km8
Message-ID: <CA+55aFyCuksrVPwO=R_xX2An8qavo17aCZ5bfN=FWo1gZZfAsQ@mail.gmail.com>
Subject: Re: [git pull] more vfs.git stuff
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 12:26 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         Regression fix from Geert + yet another open-coded kernel_read().

Hmm. I get one more commit - a racy usbmon thing. Which looks fine per
se, but would look even better if it just made mmap_active an atomic_t
instead, wouldn't you say?

So I didn't pull, waiting for clarification.

         Linus
