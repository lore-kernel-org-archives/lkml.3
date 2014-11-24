Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaKXUIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:08:17 -0500
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:38845 "EHLO
	resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754931AbaKXUIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:08:14 -0500
Date: Mon, 24 Nov 2014 14:08:11 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v7 05/12] mm: slub: introduce virt_to_obj function.
In-Reply-To: <1416852146-9781-6-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.11.1411241407580.9878@gentwo.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com> <1416852146-9781-6-git-send-email-a.ryabinin@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Andrey Ryabinin wrote:

> virt_to_obj takes kmem_cache address, address of slab page,
> address x pointing somewhere inside slab object,
> and returns address of the begging of object.

Acked-by: Christoph Lameter <cl@linux.com>
