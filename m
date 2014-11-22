Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaKVRst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 12:48:49 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58601 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaKVRsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 12:48:47 -0500
MIME-Version: 1.0
In-Reply-To: <20141122042856.GZ7996@ZenIV.linux.org.uk>
References: <20141119.165340.2162829993279387495.davem@davemloft.net>
	<20141120214753.GR7996@ZenIV.linux.org.uk>
	<20141120.182339.972861702759954603.davem@davemloft.net>
	<20141121.122615.1091044030302005883.davem@davemloft.net>
	<20141122042856.GZ7996@ZenIV.linux.org.uk>
Date: Sat, 22 Nov 2014 09:48:46 -0800
X-Google-Sender-Auth: qCO_EFYxsjQEwMV8CS1g3H65BvA
Message-ID: <CA+55aFzFKhxs=oHHHs-Kr08qWNb4+q2NO1Vgrbp++-FWfJvuQg@mail.gmail.com>
Subject: Re: [RFC] situation with csum_and_copy_... API
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 8:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         OK, here's the next bunch.

Looks like good patches to me. Not that I actually _tested_ it, or
even have a good test-case (yeah, that "historical" ATM fix? I don't
think anybody cares ;), but it all seemed sane.

              Linus
