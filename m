Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaCWQjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 12:39:22 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:39207 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaCWQjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 12:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140323121541.GA20971@rhlx01.hs-esslingen.de>
References: <alpine.LRH.2.02.1402261551010.9913@file01.intranet.prod.int.rdu2.redhat.com>
	<20140322234317.GA10483@rhlx01.hs-esslingen.de>
	<20140323121541.GA20971@rhlx01.hs-esslingen.de>
Date: Sun, 23 Mar 2014 09:39:16 -0700
X-Google-Sender-Auth: MX0Ag6yiAiViq2HDXlu5uaDdGGI
Message-ID: <CA+55aFyu_5eE5j2LLjhEQSAOAiLyuA65Z2o_TGdvhVMedWKTwA@mail.gmail.com>
Subject: Re: 3.14-rc7 crashes in drm ([PATCH] a crash in mga_driver_irq_uninstall)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, David Airlie <airlied@linux.ie>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 5:15 AM, Andreas Mohr <andi@lisas.de> wrote:
>
> which did end up flawless on 3.12.0-rc2+, too
> (but failed to improve the issue on 3.14.0-rc7+).
>
> So, for all intents and purposes, drm infrastructure seems unavoidably
> (neither dri disable nor libdrm upgrade helps) affected.
> Does anyone know which change caused that issue?
> (I'm asking because bisect here would be relatively painful).

So 3.12-rc2 works. Does 3.13 work? Is this a regression in the current
3.14 rc only, or did it happen already in the previous release?

               Linus
