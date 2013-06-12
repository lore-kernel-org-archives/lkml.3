Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3FLGKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 02:10:21 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:46525 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3FLGKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 02:10:20 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFztTY8gGh=eLD65QuaUA8dpKxXqJbQimV+7PnbWqMDyzw@mail.gmail.com>
References: <20130611210414.GN8211@linux.intel.com>
	<CA+55aFztTY8gGh=eLD65QuaUA8dpKxXqJbQimV+7PnbWqMDyzw@mail.gmail.com>
Date: Tue, 11 Jun 2013 23:10:18 -0700
X-Google-Sender-Auth: g2YR-zZZQ4fjaKkFiwLhKPIiKsg
Message-ID: <CA+55aFzzJfBjJXrF2ycRGbnSGyc6U_H4g5f59gAkAr40S4c3wA@mail.gmail.com>
Subject: Re: [PULL REQUEST] NVMe driver fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-nvme@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 8:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It's after -rc5, and this pattern of "stuff comes in quite late in the
> merge window, and then even later in the rc series" is getting really
> tiresome.

Gaah. I took it. I still don't like the timing here, but looking at
the commits I can't see a reason for dropping it.

               Linus
