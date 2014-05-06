Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbaEFB0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:26:23 -0400
Received: from ozlabs.org ([103.22.144.67]:54058 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933432AbaEFB0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:26:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
In-Reply-To: <53678ED6.4070502@infradead.org>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com> <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com> <87wqf1oi22.fsf@rustcorp.com.au> <20140502153409.329d3b5b426275e8197251a2@linux-foundation.org> <871tw9c6kt.fsf@rustcorp.com.au> <53678ED6.4070502@infradead.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 06 May 2014 10:27:43 +0930
Message-ID: <87eh07bu60.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:
> All looks good to me except for 2 instances of "eg" which should be
> "e.g." (just above and about 4 paragraphs below here).

Thanks, fixed:

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 56a4c2d0c741..a42b9dd6b46b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -14,7 +14,7 @@ environment, others are passed as command line arguments to init.
 Everything after "--" is passed as an argument to init.
 
 Module parameters can be specified in two ways: via the kernel command
-line with a module name prefix, or via modprobe, eg:
+line with a module name prefix, or via modprobe, e.g.:
 
 	(kernel command line) usbcore.blinkenlights=1
 	(modprobe command line) modprobe usbcore blinkenlights=1
@@ -30,7 +30,7 @@ Hyphens (dashes) and underscores are equivalent in parameter names, so
 can also be entered as
 	log-buf-len=1M print_fatal_signals=1
 
-Double-quotes can be used to protect spaces in values, eg:
+Double-quotes can be used to protect spaces in values, e.g.:
 	param="spaces in here"
 
 This document may not be entirely up to date and comprehensive. The command
