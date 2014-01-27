Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaA0MdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 07:33:25 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:43379 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbaA0MdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 07:33:23 -0500
MIME-Version: 1.0
Date: Mon, 27 Jan 2014 15:33:22 +0300
Message-ID: <CACVxJT9aBNw6zbOdn+S98zSx6xZ5YkHXBtyJnf9VWYaf1o5GzA@mail.gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, pali.rohar@gmail.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> Perhaps we could also generate the most common variants as:
>
>  #define PERM__rw_r__r__ 0644

You're not alone!
http://lkml.indiana.edu/hypermail/linux/kernel/0607.3/1325.html

But I think 0644 is obvious and the most right way.

Of course, proc should detect those (->write vs ->mode) and complain.
Something I never sent.
