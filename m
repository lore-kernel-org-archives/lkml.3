Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaIJWwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 18:52:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaIJWwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 18:52:20 -0400
Date: Wed, 10 Sep 2014 15:52:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>, Masanari Iida <standby24x7@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-doc <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2] checkpatch: look for common misspellings
Message-Id: <20140910155219.3d21aef2df8b1754a736cc1a@linux-foundation.org>
In-Reply-To: <20140908181524.GA11839@www.outflux.net>
References: <20140908181524.GA11839@www.outflux.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014 11:15:24 -0700 Kees Cook <keescook@chromium.org> wrote:

> Check for misspellings, based on Debian's lintian list. Several false
> positives were removed, and several additional words added that were
> common in the kernel:
> 
> 	backword backwords
> 	invalide valide
> 	recieves
> 	singed unsinged
> 
> While going back and fixing existing spelling mistakes isn't a high
> priority, it'd be nice to try to catch them before they hit the tree.

I have a feeling this is going to be a rat hole and that
scripts/spelling.txt will grow to consume the planet.  Oh well, whatev.

Have a kernel joke:

--- a/scripts/spelling.txt~checkpatch-look-for-common-misspellings-fix
+++ a/scripts/spelling.txt
@@ -553,6 +553,7 @@ jeffies||jiffies
 juse||just
 jus||just
 kown||known
+kubys|linus
 langage||language
 langauage||language
 langauge||language
_

