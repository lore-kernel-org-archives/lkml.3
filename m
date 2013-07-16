Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab3GPFov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:44:51 -0400
Received: from ozlabs.org ([203.10.76.45]:34674 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab3GPFoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:44:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: anish singh <anish198519851985@gmail.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
        Tim Abbott <tabbott@ksplice.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: Question:Bsearch replace the search_extable implementations
In-Reply-To: <CAK7N6vokZpFJkYapajhqTYWvPVWr6ELz+5Nq9yvf0J5VAx=JBA@mail.gmail.com>
References: <CAK7N6vokZpFJkYapajhqTYWvPVWr6ELz+5Nq9yvf0J5VAx=JBA@mail.gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 16 Jul 2013 14:29:17 +0930
Message-ID: <87zjtnyuai.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anish singh <anish198519851985@gmail.com> writes:
> Hello Rusty,
>
> Right now I see so many places in the kernel
> where we open code binary search implementations
> such as search_extable implementations.
>
> http://lxr.free-electrons.com/ident?a=powerpc;i=search_extable
>
> Would it be ok to replace this with bsearch lib code?
>
> I am not trying to fix any problem nor I see
> any problem in current implementations but
> if we can replace the large amount of code
> would it not be a good reason to send a patch
> for this?

It should be fine, yes.

Thanks!
Rusty.
