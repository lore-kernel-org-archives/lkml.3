Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaLHTBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:01:45 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:57326 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLHTBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:01:43 -0500
MIME-Version: 1.0
In-Reply-To: <20141208185635.GA25867@node.dhcp.inet.fi>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
	<20141208164650.GB29028@node.dhcp.inet.fi>
	<20141208175805.GB22149@ZenIV.linux.org.uk>
	<20141208185635.GA25867@node.dhcp.inet.fi>
Date: Mon, 8 Dec 2014 11:01:41 -0800
X-Google-Sender-Auth: Z6dZU5kvsf1ANshfJuwZhoVBHQ0
Message-ID: <CA+55aFwow9hVqNVGp7gjnnu4=A+J8vw1i22W4e7+1r1-215cHg@mail.gmail.com>
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 10:56 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>
> trinity triggers it for me in few minutes. I will try find out more once
> get some time.

You run trinity as *root*?

You're a brave man. Stupid, but brave ;)

I guess you're running it in a VM, but still.. Doing random system
calls as root sounds like a bad bad idea.

                      Linus
