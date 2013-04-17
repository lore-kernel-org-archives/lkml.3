Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3DQA5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:57:16 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50399 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3DQA5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:57:13 -0400
Date: Tue, 16 Apr 2013 17:56:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-s390@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
        viro@zeniv.linux.org.uk, sparclinux@vger.kernel.org
Subject: Re: [PATCH 01/28] Include missing linux/slab.h inclusions [RFC]
Message-ID: <20130417005653.GA11541@kroah.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182554.27773.86004.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416182554.27773.86004.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 07:25:54PM +0100, David Howells wrote:
> Include missing linux/slab.h inclusions where the source file is currently
> expecting to get kmalloc() and co. through linux/proc_fs.h.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-s390@vger.kernel.org
> cc: sparclinux@vger.kernel.org
> cc: linux-efi@vger.kernel.org
> cc: linux-mtd@lists.infradead.org
> cc: devel@driverdev.osuosl.org
> cc: x86@kernel.org
> ---
>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
