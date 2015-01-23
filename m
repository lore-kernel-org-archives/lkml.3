Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbbAWW5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:57:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbAWW5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:57:35 -0500
Date: Fri, 23 Jan 2015 14:57:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, penberg@kernel.org,
        iamjoonsoo@lge.com, Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [RFC 0/3] Slab allocator array operations
Message-Id: <20150123145734.aa3c6c6e7432bc3534f2c4cc@linux-foundation.org>
In-Reply-To: <20150123213727.142554068@linux.com>
References: <20150123213727.142554068@linux.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015 15:37:27 -0600 Christoph Lameter <cl@linux.com> wrote:

> Attached a series of 3 patches to implement functionality to allocate
> arrays of pointers to slab objects. This can be used by the slab
> allocators to offer more optimized allocation and free paths.

What's the driver for this?  The networking people, I think?  If so,
some discussion about that would be useful: who is involved, why they
have this need, who are the people we need to bug to get it tested,
whether this implementation is found adequate, etc.

