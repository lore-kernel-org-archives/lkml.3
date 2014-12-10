Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaLJR3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:29:48 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34850 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbaLJR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:29:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141210163034.078015357@linux.com>
References: <20141210163017.092096069@linux.com>
	<20141210163034.078015357@linux.com>
Date: Wed, 10 Dec 2014 19:29:45 +0200
X-Google-Sender-Auth: yW57hJGx3RTG0GVwJdJNgnEPGzo
Message-ID: <CAOJsxLGtqtDSvvSXnQBGdXFfX_osWKuQ5R8Q0ai0VMv2hQC3eg@mail.gmail.com>
Subject: Re: [PATCH 6/7] slub: Drop ->page field from kmem_cache_cpu
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm <akpm@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 6:30 PM, Christoph Lameter <cl@linux.com> wrote:
> Dropping the page field is possible since the page struct address
> of an object or a freelist pointer can now always be calcualted from
> the address. No freelist pointer will be NULL anymore so use
> NULL to signify the condition that the current cpu has no
> percpu slab attached to it.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
