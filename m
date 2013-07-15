Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3GOFTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 01:19:33 -0400
Received: from ozlabs.org ([203.10.76.45]:44154 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab3GOFTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 01:19:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Wedson Almeida Filho <wedsonaf@gmail.com>, Joe Perches <joe@perches.com>
Cc: Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
        Wedson Almeida Filho <wedsonaf@gmail.com>
Subject: Re: [PATCH v2] lib: One less subtraction in binary search iterations.
In-Reply-To: <1373351822-52050-1-git-send-email-wedsonaf@gmail.com>
References: <CANeycqoHsRqCU4BSkPYK5O++ciShAmFcpEx+D3XUha7kukU0bQ@mail.gmail.com> <1373351822-52050-1-git-send-email-wedsonaf@gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 15 Jul 2013 14:37:21 +0930
Message-ID: <87ehb01kdy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wedson Almeida Filho <wedsonaf@gmail.com> writes:
> The subtraction is removed at the expense of generality: when the element size
> is 1, the array length cannot exceed half the architecture's addressable
> memory.

People do copy code, so I prefer to set the best example possible.

Unless it's a useful optimization, I think it should stay the way it is.

Cheers,
Rusty.
