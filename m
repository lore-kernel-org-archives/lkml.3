Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaLZFwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 00:52:34 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40987 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaLZFw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 00:52:29 -0500
MIME-Version: 1.0
In-Reply-To: <20141225123014.GO16916@distanz.ch>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1419423766-114457-27-git-send-email-kirill.shutemov@linux.intel.com>
	<20141225123014.GO16916@distanz.ch>
Date: Fri, 26 Dec 2014 13:52:27 +0800
X-Google-Sender-Auth: P-a2hSdFZu3H5JzOGqRWynUiZJo
Message-ID: <CAFiDJ59P7DPTfBN5PrhXjTLhku0U+ZYBv_0qdmjtbBNN0T2h3A@mail.gmail.com>
Subject: Re: [PATCH 26/38] nios2: drop _PAGE_FILE and pte_file()-related helpers
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        akpm@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        davej@redhat.com, sasha.levin@oracle.com,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 8:30 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
> On 2014-12-24 at 13:22:34 +0100, Kirill A. Shutemov <kirill.shutemov@linux.intel.com> wrote:
>> We've replaced remap_file_pages(2) implementation with emulation.
>> Nobody creates non-linear mapping anymore.
>>
>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> Cc: Ley Foon Tan <lftan@altera.com>
>
> Reviewed-by: Tobias Klauser <tklauser@distanz.ch>

Acked-by: Ley Foon Tan <lftan@altera.com>
