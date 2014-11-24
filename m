Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036AbaKXVhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:37:35 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:64952 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKXVhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:37:34 -0500
Date: Mon, 24 Nov 2014 13:37:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
cc: Christoph Lameter <cl@linux.com>, Min-Hua Chen <orca.chen@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] slub: fix confusing error messages in check_slab
In-Reply-To: <CAPAsAGxbA-3gi+vgoK2NtPM4UOeARw2+5xJtnp1kh8VzrfOHeg@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1411241336000.21237@chino.kir.corp.google.com>
References: <CAHkaATSEn9WMKJNRp5QvzPsno_vddtMXY39yvi=BGtb4M+Hqdw@mail.gmail.com> <alpine.DEB.2.11.1411241117030.8951@gentwo.org> <CAPAsAGxbA-3gi+vgoK2NtPM4UOeARw2+5xJtnp1kh8VzrfOHeg@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Andrey Ryabinin wrote:

> It's in -mm already
> http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-format-mismatches-in-slab_err-callers.patch
> 

Yeah, and the one in -mm isn't whitespace damaged.  Since the issue has 
existed for years, I don't think there's any rush in getting this in 3.18.
