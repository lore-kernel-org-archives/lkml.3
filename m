Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaHHMGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:06:19 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:53812 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHHMGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:06:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1408080649430.14841@gentwo.org>
References: <CAMuHMdW2kb=EF-Nmem_gyUu=p7hFOTe+Q2ekHh41SaHHiWDGeg@mail.gmail.com>
	<CAAmzW4MX2birtCOUxjDdQ7c3Y+RyVkBt383HEQ=XFgnhhOsQPw@mail.gmail.com>
	<CAMuHMdVC8aYwDEHnntshdVA24Nx3qAUXZfeRQNGqj=J6eExU-Q@mail.gmail.com>
	<CAAmzW4NWnMeO+Z3CQ=9Z7rUFLaPmR-w0iMhxzjO+PVgVu7OMuQ@mail.gmail.com>
	<20140808071903.GD6150@js1304-P5Q-DELUXE>
	<CAMuHMdVHmmct=BC=WXFJWeizYp+S706WjvNi=powYsJkarKUhw@mail.gmail.com>
	<alpine.DEB.2.11.1408080649430.14841@gentwo.org>
Date: Fri, 8 Aug 2014 14:06:16 +0200
X-Google-Sender-Auth: cOp8alWgybjRZxV5cE33xu7Z2o8
Message-ID: <CAMuHMdWNNuPgDsjM1eM0uo2090-6OxAX8Kfw8Pcd2zo5G6zPkw@mail.gmail.com>
Subject: Re: BUG: enable_cpucache failed for radix_tree_node, error 12 (was:
 Re: [PATCH v3 9/9] slab: remove BAD_ALIEN_MAGIC)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, Aug 8, 2014 at 1:50 PM, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 8 Aug 2014, Geert Uytterhoeven wrote:
>> > Of possible, could you check whether page_to_nid(page) returns
>> > only 0 or not?
>>
>> It returns 0 or 1.
>
> Ok this is broken on m68k. CONFIG_NUMA is required for this to work. If
> the arch code does this despite !CONFIG_NUMA then lots of things should
> break.

Can you please elaborate? We've been using for years...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
