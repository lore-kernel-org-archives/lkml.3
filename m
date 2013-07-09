Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3GIE6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 00:58:21 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:47804 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3GIE6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 00:58:20 -0400
MIME-Version: 1.0
In-Reply-To: <1373343147.9458.25.camel@joe-AO722>
References: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com>
	<1373173169.1943.1.camel@joe-AO722>
	<CANeycqqGYKs+Q+_6zpjfdQ+y-QBZLD+jGdU9-YJi9XaYXyCv-w@mail.gmail.com>
	<1373343147.9458.25.camel@joe-AO722>
Date: Mon, 8 Jul 2013 21:58:20 -0700
Message-ID: <CANeycqoHsRqCU4BSkPYK5O++ciShAmFcpEx+D3XUha7kukU0bQ@mail.gmail.com>
Subject: Re: [PATCH] lib: One less subtraction in binary search iterations.
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 9:12 PM, Joe Perches <joe@perches.com> wrote:
>> There is no functional change, but this change eliminates a subtraction that
>> the compiler doesn't optimize out (as of gcc 4.7.3).
>
> That's flatly incorrect.

I'm not arguing this. I in fact already acknowledged that the
statement is incorrect.

> I don't mind if you change it, for just the reason
> you wrote, but you still have to now say under what
> conditions the test works and when it doesn't.

Yes, I'll update and respin the patch as also suggested by Rusty.

Thanks for the review.
