Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbaLOFxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 00:53:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaLOFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 00:53:12 -0500
Date: Sun, 14 Dec 2014 21:53:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-aio@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [GIT PULL] aio: changes for 3.19
Message-Id: <20141214215318.b2b41f06.akpm@linux-foundation.org>
In-Reply-To: <20141214223936.GJ2672@kvack.org>
References: <20141214202224.GH2672@kvack.org>
	<CA+55aFxV2h1NrE87Zt7U8bsrXgeO=Tf-DyQO8wBYZ=M7WEjxKg@mail.gmail.com>
	<20141214215221.GI2672@kvack.org>
	<20141214141336.a0267e95.akpm@linux-foundation.org>
	<20141214223936.GJ2672@kvack.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 17:39:36 -0500 Benjamin LaHaise <bcrl@kvack.org> wrote:

> How about the documentation/comment updates below?

lgtm.

> ...
>
> +/* aio_ring_remap()
> + *	Called when th aio event ring is being relocated within the process'

"the"

> + *	address space.  The primary purpose is to update the saved address of
> + *	the aio event ring so that when the ioctx is detroyed, it gets removed
> + *	from the correct userspace address.  This is typically used when
> + *	reloading a process back into memory by checkpoint-restore.
> + */
>  static void aio_ring_remap(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
