Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbaLJQjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:39:22 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41794 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbaLJQjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:39:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141210163033.497862168@linux.com>
References: <20141210163017.092096069@linux.com>
	<20141210163033.497862168@linux.com>
Date: Wed, 10 Dec 2014 18:39:20 +0200
X-Google-Sender-Auth: I2KP6KMFqzrXT88hysK_-jTKsPY
Message-ID: <CAOJsxLHBehVLj=xzPNKc_ndnqwBte9r9yj-rSsxatuFXa=N1ew@mail.gmail.com>
Subject: Re: [PATCH 1/7] slub: Remove __slab_alloc code duplication
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
> Somehow the two branches in __slab_alloc do the same.
> Unify them.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
