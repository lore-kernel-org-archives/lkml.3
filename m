Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab3JQGYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:24:46 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:60306 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3JQGYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:24:45 -0400
MIME-Version: 1.0
In-Reply-To: <87haci9ivu.fsf@rustcorp.com.au>
References: <1381833790-18687-1-git-send-email-artagnon@gmail.com> <87haci9ivu.fsf@rustcorp.com.au>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 17 Oct 2013 11:54:04 +0530
Message-ID: <CALkWK0k95+sW5jM5AOgkwo_qHfEdy=A4ctAbRxMd7DtVTE+cCg@mail.gmail.com>
Subject: Re: [PATCH] virtio tools: use ansi versions of asm and volatile
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Ramkumar Ramachandra <artagnon@gmail.com> writes:
>> asm and volatile are provided for backward compatibility; use the ansi
>> versions __asm__ and __volatile__.
>
> Really?  I don't see that in the gcc documentation.  In fact, I didn't
> know __volatile__ at all:

Try compiling the program with `gcc -ansi`, and you'll see that "asm"
and "volatile" are undeclared. The motivation for my patch comes from
barrier() being declared differently in compiler-gcc.h.

However, the tree is polluted with the non-ansi versions anyway;
compilers will continue to support them for decades. So, I'd request
you to drop the patch.

Thanks.
