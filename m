Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaIYSHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:07:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaIYSH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:07:27 -0400
Date: Thu, 25 Sep 2014 11:07:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: rdunlap@infradead.org, viro@zeniv.linux.org.uk, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@codethink.co.uk, keescook@chromium.org,
        penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH RESUBMIT 1/2] fs/seq_file: Create new function
 seq_open_init()
Message-Id: <20140925110725.71eea76c45b74a0f8f3689c2@linux-foundation.org>
In-Reply-To: <542456E0.1040404@codethink.co.uk>
References: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk>
	<1411557356-10673-2-git-send-email-rob.jones@codethink.co.uk>
	<20140924143904.b6f12611013876253d8ac50a@linux-foundation.org>
	<5423DBED.4090306@codethink.co.uk>
	<20140925105033.ae4684eef16b5a323b9dbdd6@linux-foundation.org>
	<542456E0.1040404@codethink.co.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014 18:54:40 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:

> On 25/09/14 18:50, Andrew Morton wrote:
> > On Thu, 25 Sep 2014 10:10:05 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:
> >
> >>> A global exported-to-modules interface should be documented, please.
> >>> Especially when it has a void* argument.  seq_file.c is patchy - some
> >>> of it is documented, some of it uses the read-programmers-mind
> >>> approach.
> >>
> >> I have included documentation as the second patch. Would it have been
> >> better to include them in a single patch? I didn't do that because
> >> seq_file and Documentation have different maintainers. I'm still
> >> learning the protocols here.
> >
> > A single patch would be OK.
> >
> > Documentation/ is nice, but I don't think people think to look there.
> > Some kerneldoc within the .c would be a good addition.
> 
> Now is a good time, can you point me at an instance of good practice of
> this?

Search fs/seq_file.c for "^/**"?
