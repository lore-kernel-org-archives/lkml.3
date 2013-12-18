Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3LRWIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:08:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3LRWIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 17:08:31 -0500
Date: Wed, 18 Dec 2013 14:08:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Chao Yang <chayang@redhat.com>,
        linux-mm@kvack.org, aarcange@redhat.com, mgorman@suse.de,
        Veaceslav Falico <vfalico@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>,
        Michel Lespinasse <walken@google.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm,numa,THP: initialize hstate for THP page size
Message-Id: <20131218140830.924fa0a3bab0d497db5e256c@linux-foundation.org>
In-Reply-To: <20131218170314.1e57bea7@cuia.bos.redhat.com>
References: <20131218170314.1e57bea7@cuia.bos.redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 17:03:14 -0500 Rik van Riel <riel@redhat.com> wrote:

> When hugetlbfs is started with a non-default page size, it is
> possible that no hstate is initialized for the page sized used
> by transparent huge pages.
> 
> This causes copy_huge_page to crash on a null pointer. Make
> sure we always have an hpage initialized for the page sized
> used by THP.
> 

A bit more context is needed here please - so that people can decide
which kernel version(s) need patching.

