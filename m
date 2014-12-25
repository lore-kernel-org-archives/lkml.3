Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaLYMaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 07:30:20 -0500
Received: from sym2.noone.org ([178.63.92.236]:42409 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaLYMaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 07:30:18 -0500
Date: Thu, 25 Dec 2014 13:30:15 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: akpm@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        davej@redhat.com, sasha.levin@oracle.com, hughd@google.com,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ley Foon Tan <lftan@altera.com>
Subject: Re: [PATCH 26/38] nios2: drop _PAGE_FILE and pte_file()-related
 helpers
Message-ID: <20141225123014.GO16916@distanz.ch>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1419423766-114457-27-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419423766-114457-27-git-send-email-kirill.shutemov@linux.intel.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-24 at 13:22:34 +0100, Kirill A. Shutemov <kirill.shutemov@linux.intel.com> wrote:
> We've replaced remap_file_pages(2) implementation with emulation.
> Nobody creates non-linear mapping anymore.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Ley Foon Tan <lftan@altera.com>

Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
