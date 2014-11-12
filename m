Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaKLWIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:08:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaKLWIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:08:05 -0500
Date: Wed, 12 Nov 2014 14:08:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>,
        Christoph Hellwig <hch@infradead.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCHv7 0/3] syscalls,x86: Add execveat() system call
Message-Id: <20141112140801.ae8029c7c769d1b606a76f7c@linux-foundation.org>
In-Reply-To: <1415379664-31555-1-git-send-email-drysdale@google.com>
References: <1415379664-31555-1-git-send-email-drysdale@google.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Nov 2014 17:01:01 +0000 David Drysdale <drysdale@google.com> wrote:

> This patch set adds execveat(2) for x86

I grabbed these.  If someone else was planning to do so, feel free to
shout at me.

I haven't been following the discussion closely so some reviewed-by's
and tested-by's would be nice.

Thanks for writing a manpage.  mtk.manpages@gmail.com should have been
cc'ed.  He is now ;)

Your syscall number was taken by sys_bpf.  I renumbered it
appropriately.

