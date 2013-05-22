Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3EVLpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:45:45 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:34062 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3EVLpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:45:42 -0400
MIME-Version: 1.0
In-Reply-To: <1368321816-17719-31-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1368321816-17719-31-git-send-email-kirill.shutemov@linux.intel.com>
Date: Wed, 22 May 2013 19:45:42 +0800
Message-ID: <CAJd=RBD3e0pJAt4QjE0CELCobSpiCWtYL5z5Ze7v8amuP3YJDA@mail.gmail.com>
Subject: Re: [PATCHv4 30/39] thp: do_huge_pmd_anonymous_page() cleanup
From: Hillf Danton <dhillf@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave@sr71.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 9:23 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Minor cleanup: unindent most code of the fucntion by inverting one
> condition. It's preparation for the next patch.
>
> No functional changes.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
Acked-by: Hillf Danton <dhillf@gmail.com>
