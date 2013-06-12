Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab3FLDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 23:09:29 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:36270 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3FLDJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:09:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130611210414.GN8211@linux.intel.com>
References: <20130611210414.GN8211@linux.intel.com>
Date: Tue, 11 Jun 2013 20:09:24 -0700
X-Google-Sender-Auth: V8Z4QePuVa-OxAeKXDNOmytOwlE
Message-ID: <CA+55aFztTY8gGh=eLD65QuaUA8dpKxXqJbQimV+7PnbWqMDyzw@mail.gmail.com>
Subject: Re: [PULL REQUEST] NVMe driver fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-nvme@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 2:04 PM, Matthew Wilcox <willy@linux.intel.com> wrote:
>
> The following bugfixes have been accumulating for the last few weeks, and
> it would be nice if they could be in 3.10.

So I'm not in the least sure I should bother with the whole nvme thing.

It's after -rc5, and this pattern of "stuff comes in quite late in the
merge window, and then even later in the rc series" is getting really
tiresome.

I'm getting a strong signal of "this driver isn't something people
bother to actually maintain". Do you even have access to hardware by
now? I've gotten all of four pull requests for this driver if I look
at the logs correctly, and of those four pull requests one was after
an rc7, and now this is after an rc5.

Simple question: is it worth the bother?

                 Linus
