Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaKXRkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:40:03 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59940 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaKXRkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:40:02 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411241117030.8951@gentwo.org>
References: <CAHkaATSEn9WMKJNRp5QvzPsno_vddtMXY39yvi=BGtb4M+Hqdw@mail.gmail.com>
	<alpine.DEB.2.11.1411241117030.8951@gentwo.org>
Date: Mon, 24 Nov 2014 21:40:01 +0400
Message-ID: <CAPAsAGxbA-3gi+vgoK2NtPM4UOeARw2+5xJtnp1kh8VzrfOHeg@mail.gmail.com>
Subject: Re: [PATCH] slub: fix confusing error messages in check_slab
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Min-Hua Chen <orca.chen@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-24 20:17 GMT+03:00 Christoph Lameter <cl@linux.com>:
> On Mon, 24 Nov 2014, Min-Hua Chen wrote:
>
>> In check_slab, s->name is passed incorrectly to the error
>> messages. It will cause confusing error messages if the object
>> check fails. This patch fix this bug by removing s->name.
>
> I have seen a patch like thios before.
>

It's in -mm already
http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-format-mismatches-in-slab_err-callers.patch

> Acked-by: Christoph Lameter <cl@linux.com>
>
