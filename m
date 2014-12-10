Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbaLJQpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:45:20 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62083 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaLJQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:45:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141210163033.612898004@linux.com>
References: <20141210163017.092096069@linux.com>
	<20141210163033.612898004@linux.com>
Date: Wed, 10 Dec 2014 18:45:18 +0200
X-Google-Sender-Auth: PugYcBaooi87ltOfN9I9Ksk-TwI
Message-ID: <CAOJsxLHk6jUej0kqBtUnjUbEKOfZDRaSLyG_f=TJm9ogLZbArA@mail.gmail.com>
Subject: Re: [PATCH 2/7] slub: Use page-mapping to store address of page frame
 like done in SLAB
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
> SLAB uses the mapping field of the page struct to store a pointer to the
> begining of the objects in the page frame. Use the same field to store
> the address of the objects in SLUB as well. This allows us to avoid a
> number of invocations of page_address(). Those are mostly only used for
> debugging though so this should have no performance benefit.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
