Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaDARB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:01:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57126 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaDARB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:01:56 -0400
Date: Tue, 1 Apr 2014 17:59:47 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Yury Gribov <y.gribov@samsung.com>,
        Alexandr Andreev <aandreev@parallels.com>,
        Vassili Karpov <av1474@comtv.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH RFC] drivers/char/mem: byte generating devices and
 poisoned mappings
Message-ID: <20140401175947.5b5a3298@alan.etchedpixels.co.uk>
In-Reply-To: <20140331211607.26784.43976.stgit@zurg>
References: <20140331211607.26784.43976.stgit@zurg>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2014 01:16:07 +0400
Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> This patch adds 256 virtual character devices: /dev/byte0, ..., /dev/byte255.
> Each works like /dev/zero but generates memory filled with particular byte.

More kernel code for an ultra-obscure corner case that can be done in
user space

I don't see the point

Alan
