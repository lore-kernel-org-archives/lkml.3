Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3H3LTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:19:47 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:56207 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab3H3LTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:19:45 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130830103633.GG10002@twins.programming.kicks-ass.net>
References: <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<20130830094857.GA14502@gmail.com>
	<CA+icZUX5F8NtZkc1WsFZC8ggs0K7O=dk2iyhwCDi7FQz+7cHeQ@mail.gmail.com>
	<CA+icZUVKkVuOCf1h-g8-XZ=Kjt6aLF7Yh9Mt90hbNa7q0jsvQA@mail.gmail.com>
	<CA+icZUVnfVcYdc7XHyM9oA5GF-HG35JghWNabE4pgvBvTh1E0g@mail.gmail.com>
	<20130830103633.GG10002@twins.programming.kicks-ass.net>
Date: Fri, 30 Aug 2013 13:19:43 +0200
Message-ID: <CA+icZUUsa+TytTva_fg-4=NoYQfLP_d+QrugNPXuWuOr606hgQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Aug 30, 2013 at 12:29:34PM +0200, Sedat Dilek wrote:
>> [ Sorry for being off-topic ]
>>
>> Hey Ingo,
>>
>> can you help, please?
>>
>> I installed so far all missing -dev packages...
>>
>> $ sudo apt-get install libelf-dev libdw-dev libunwind7-dev libslang2-dev
>
> It seems to me the easier way is:
>
>  $ apt-get build-dep linux-tools
>

The B-Ds for latest linux-tools (3.11~rc4-1~exp1) in
Debian/experimental look like this:

Build-Depends: debhelper (>> 7), python, asciidoc, binutils-dev,
bison, flex, libdw-dev, libelf-dev, libnewt-dev, libperl-dev,
python-dev, xmlto, autoconf, automake, libtool, libglib2.0-dev,
libsysfs-dev, libwrap0-dev

- Sedat -

[1] http://ftp.de.debian.org/debian/pool/main/l/linux-tools/linux-tools_3.11~rc4-1~exp1.dsc
