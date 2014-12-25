Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaLYKZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 05:25:33 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:57169 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaLYKZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 05:25:29 -0500
MIME-Version: 1.0
In-Reply-To: <1419423766-114457-39-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1419423766-114457-39-git-send-email-kirill.shutemov@linux.intel.com>
Date: Thu, 25 Dec 2014 13:25:28 +0300
Message-ID: <CAMo8BfLdm0dRd60ZQ9rROg3QvDR_Zjz0qW31e8LgxyhrsKMCwA@mail.gmail.com>
Subject: Re: [PATCH 38/38] xtensa: drop _PAGE_FILE and pte_file()-related helpers
From: Max Filippov <jcmvbkbc@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        davej@redhat.com, sasha.levin@oracle.com,
        Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 3:22 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> We've replaced remap_file_pages(2) implementation with emulation.
> Nobody creates non-linear mapping anymore.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  arch/xtensa/include/asm/pgtable.h | 10 ----------
>  1 file changed, 10 deletions(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
