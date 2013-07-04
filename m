Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab3GDHlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:41:17 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:48442 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3GDHlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:41:15 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130704160652.4f76f0ee43877a6e726d6c8b@canb.auug.org.au>
References: <20130704160652.4f76f0ee43877a6e726d6c8b@canb.auug.org.au>
Date: Thu, 4 Jul 2013 09:41:14 +0200
Message-ID: <CA+icZUXchb2H=ZZ0Zv+vA43x0CNVSbLvPptawnBR+OUpOzqP6A@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 4
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 4, 2013 at 8:06 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130703:
>
> The net-next tree lost its build failure.
>
> The akpm tree gained a conflict against the kbuild tree and lost lots of
> patches that turned up elsewhere.
>
> ----------------------------------------------------------------------------
>

Just FYI:
People building with "CONFIG_MEMCG_KMEM=n" (still) need an extra patch
pending in mmots-tree [1].
( Unfortunately, it does not cleanly apply against next-20130704. )

- Sedat -

[1] http://ozlabs.org/~akpm/mmots/broken-out/memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix.patch
