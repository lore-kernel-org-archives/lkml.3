Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbbAHMCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:02:07 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56046 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbbAHMCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:02:05 -0500
MIME-Version: 1.0
In-Reply-To: <1420421851-3281-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1420421851-3281-1-git-send-email-iamjoonsoo.kim@lge.com> <1420421851-3281-3-git-send-email-iamjoonsoo.kim@lge.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 8 Jan 2015 12:01:43 +0000
X-Google-Sender-Auth: sztRAkKWwp0YZT1171H-lwegHpY
Message-ID: <CAHkRjk6Lfm4aOHaw6M7ug6DxvmKr1RtuqzfB6k2moJW9VvHAUQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] mm/slab: remove kmemleak_erase() call
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 January 2015 at 01:37, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> We already call kmemleak_no_scan() in initialization step of array cache,
> so kmemleak doesn't scan array cache. Therefore, we don't need to call
> kmemleak_erase() here.
>
> And, this call is the last caller of kmemleak_erase(), so remove
> kmemleak_erase() definition completely.

Good point.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin
