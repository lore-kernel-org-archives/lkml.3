Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaA0XNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:13:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaA0XNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:13:51 -0500
Date: Mon, 27 Jan 2014 15:13:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] lib: Export interval_tree
Message-Id: <20140127151350.e44323b007f00229ac831a90@linux-foundation.org>
In-Reply-To: <1390739073-4519-1-git-send-email-chris@chris-wilson.co.uk>
References: <1390316872-15887-1-git-send-email-chris@chris-wilson.co.uk>
	<1390739073-4519-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jan 2014 12:24:33 +0000 Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Note for maintainers, this is being proposed for use by i915.ko, so it
> may make the most sense to merge it via the drm/i915 tree in the next
> cycle.

Yes, please proceed that way.
