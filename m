Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab3GBSnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:43:19 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:54510 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3GBSnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:43:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130701171759.GA25767@kroah.com>
References: <20130701171759.GA25767@kroah.com>
Date: Tue, 2 Jul 2013 11:43:17 -0700
X-Google-Sender-Auth: 8X0PLUz02v0LbVyo_3yfAOv_ipk
Message-ID: <CA+55aFx+RcyqT6smdcH0MOPRRJzUgHtY0t5DD5-EngjePxw0CA@mail.gmail.com>
Subject: Re: [GIT PATCH] Staging driver patches for 3.11-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 10:17 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:
>
>   Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ staging-next

Hmm. I think you meant the "staging-3.11-rc1" tag, not the
"staging-next" branch..

            Linus
