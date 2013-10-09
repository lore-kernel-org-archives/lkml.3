Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3JIRSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:18:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:52979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab3JIRSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:18:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1064,1371106800"; 
   d="scan'208";a="414403671"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20131009164951.GA29751@localhost>
References: <20131009164951.GA29751@localhost>
Subject: RE: [page->ptl] BUG: unable to handle kernel NULL pointer dereference
 at 00000010
Content-Transfer-Encoding: 7bit
Message-Id: <20131009171828.693D0E0090@blue.fi.intel.com>
Date: Wed,  9 Oct 2013 20:18:28 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit c7727a852968b09a9a5756dc7c85c30287c6ada3
> Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Date:   Wed Oct 9 16:45:45 2013 +0300
> 
>     mm: dynamic allocate page->ptl if it cannot be embedded to struct page
>     
>     Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Thanks, I'll fix it tomorrow.

Just to clarify: the commit is from my devel branch. It doesn't affect any
upstream tree.

-- 
 Kirill A. Shutemov
