Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063AbaLKPYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:24:45 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:60614 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964973AbaLKPYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:24:44 -0500
Date: Thu, 11 Dec 2014 10:24:23 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: akpm@linux-foundation.org, cl@linux.com, jmarchan@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com,
        aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add fields for compound destructor and order into
 struct page
Message-ID: <20141211152423.GA21603@phnom.home.cmpxchg.org>
References: <1418304027-154173-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418304027-154173-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 03:20:27PM +0200, Kirill A. Shutemov wrote:
> Currently, we use lru.next/lru.prev plus cast to access or set
> destructor and order of compound page.
> 
> Let's replace it with explicit fields in struct page.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
