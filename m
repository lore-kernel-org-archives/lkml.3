Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaCNUI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbaCNUI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:08:57 -0400
Date: Fri, 14 Mar 2014 16:08:46 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
Message-ID: <20140314200846.GA6633@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sasha.levin@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
 <5321CBDA.1060705@oracle.com>
 <CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
 <20140313231227.GA32178@redhat.com>
 <CAGXu5jLE6WHCwZVcMSUwQAa3=DW1LsxGd_1aGo8SzLpk8jC-xA@mail.gmail.com>
 <20140314190824.GA6426@redhat.com>
 <CA+55aFznCT20giHq8JxCRduky-dQtVLqpUYrcrK_3XeXN+Wyow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFznCT20giHq8JxCRduky-dQtVLqpUYrcrK_3XeXN+Wyow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 12:32:23PM -0700, Linus Torvalds wrote:
 > On Fri, Mar 14, 2014 at 12:08 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > ok, nokalsr makes it work too.
 > > Booting with that and using the perf binary from 3.14rc6 , I just see..
 > >
 > >   9.30%  [kernel]                      [k] 0xffffffffaf18e887
 > 
 > Hmm. Do you have CONFIG_KALLSYMS enabled?

$ grep KALLSYMS .config
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y

mine looks like this.. http://codemonkey.org.uk/junk/kallsyms

 > I have CONFIG_RANDOMIZE_BASE=y and perf (both report and top) seems to
 > work fine for me (current git, not v3.14-rc6, but still)

yeah, on current now too.

CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000


	Dave

