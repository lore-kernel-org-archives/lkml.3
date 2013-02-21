Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3BUCZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:25:23 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:38053 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3BUCZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:25:22 -0500
MIME-Version: 1.0
In-Reply-To: <CANZA+xgRWQe2fm8Gok4SxRXEeRU5CztijG4HKNeTDFQfSgHPPw@mail.gmail.com>
References: <CANZA+xgRWQe2fm8Gok4SxRXEeRU5CztijG4HKNeTDFQfSgHPPw@mail.gmail.com>
Date: Thu, 21 Feb 2013 10:25:20 +0800
Message-ID: <CANZA+xgjxezRuu4N2JpXbXjpKCz7825x_ZmdOe-DuxtMzGix-A@mail.gmail.com>
Subject: Re: What does the PG_swapbacked of page flags actually mean?
From: common An <xx.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linaro-kernel@lists.linaro.org, riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 6:43 PM, common An <xx.kernel@gmail.com> wrote:
> PG_swapbacked is a bit for page->flags.
>
> In kernel code, its comment is "page is backed by RAM/swap". But I couldn't
> understand it.
> 1. Does the RAM mean DRAM? How page is backed by RAM?
> 2. When the page is page-out to swap file, the bit PG_swapbacked will be set
> to demonstrate this page is backed by swap. Is it right?
> 3. In general, when will call SetPageSwapBacked() to set the bit?

>From : http://www.gossamer-threads.com/lists/linux/kernel/840692#840692

Every anonymous, tmpfs or shared memory segment page is potentially
swap backed. That is the whole point of the PG_swapbacked flag.

A page from a filesystem like ext3 or NFS cannot suddenly turn into
a swap backed page. This page "nature" is not changed during the
lifetime of a page.

But, I am still a little confusing.

>
> Could anybody kindly explain for me?
>
> Thanks very much.
