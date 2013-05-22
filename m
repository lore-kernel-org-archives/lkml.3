Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3EVGvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:51:43 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46117 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3EVGvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:51:40 -0400
MIME-Version: 1.0
In-Reply-To: <1368321816-17719-32-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1368321816-17719-32-git-send-email-kirill.shutemov@linux.intel.com>
Date: Wed, 22 May 2013 14:51:39 +0800
Message-ID: <CAJd=RBAV+dm2UE-kJ_SfW5mP9G+y5zcmgPoQQ6QAiiMEraWf5w@mail.gmail.com>
Subject: Re: [PATCHv4 31/39] thp: consolidate code between handle_mm_fault()
 and do_huge_pmd_anonymous_page()
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
> do_huge_pmd_anonymous_page() has copy-pasted piece of handle_mm_fault()
> to handle fallback path.
>
> Let's consolidate code back by introducing VM_FAULT_FALLBACK return
> code.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---

Acked-by: Hillf Danton <dhillf@gmail.com>
