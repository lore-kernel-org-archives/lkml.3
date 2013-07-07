Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3GGPrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 11:47:46 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51409 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3GGPrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 11:47:45 -0400
MIME-Version: 1.0
In-Reply-To: <1371623635-26575-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1371623635-26575-1-git-send-email-iamjoonsoo.kim@lge.com>
Date: Sun, 7 Jul 2013 18:47:43 +0300
X-Google-Sender-Auth: s7yYIT5jPxLcIsU7NITttH0w0w8
Message-ID: <CAOJsxLEipdF=vZrDCOipcLYnpAjXOyAgWmTznRt0rsiHPRfTPA@mail.gmail.com>
Subject: Re: [PATCH] slub: do not put a slab to cpu partial list when
 cpu_partial is 0
From: Pekka Enberg <penberg@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 9:33 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> In free path, we don't check number of cpu_partial, so one slab can
> be linked in cpu partial list even if cpu_partial is 0. To prevent this,
> we should check number of cpu_partial in put_cpu_partial().
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Applied, thanks a lot!
