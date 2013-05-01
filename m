Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568Ab3EAQY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:24:26 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61469 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761489Ab3EAQYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:24:19 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1305011209370.929-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1304291706360.1152-100000@iolanthe.rowland.org>
	<Pine.LNX.4.44L0.1305011209370.929-100000@iolanthe.rowland.org>
Date: Wed, 1 May 2013 09:24:18 -0700
X-Google-Sender-Auth: oK2qj0AfIMJ6X6xpucIhJz07b38
Message-ID: <CA+55aFyaQsOpJu=jkFmQyQrBNG7fyh8Vqy1eUCFKVug1s_P+QA@mail.gmail.com>
Subject: Re: [PATCH] USB: remove remaining instances of USB_SUSPEND
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 9:13 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> This patch (as1677) removes the remaining instances of that symbol.

Btw, what are these "asXXXX" ID's, and what does the noise buy us?

Doing a

  git log | egrep -w 'as[0-9]{3,}'

shows that this has been going on forever, but it still doesn't make
any *sense*. It adds nothing worthwhile. In fact, doing

  git log | grep 'This patch ('

shows that you're pretty the only one doing it, but there's *one*
other one jidong xiao: jx001. I really don't see the advantage of
having this kind of random noise in the kernel logs.

                    Linus
