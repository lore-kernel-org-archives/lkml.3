Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaF3MCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:02:44 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:58395 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbaF3MC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:02:29 -0400
Date: Mon, 30 Jun 2014 15:02:18 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v3 05/13] clear_refs: remove clear_refs_private->vma and
 introduce clear_refs_test_walk()
Message-ID: <20140630120218.GU19833@node.dhcp.inet.fi>
References: <1403295099-6407-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1403295099-6407-6-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403295099-6407-6-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 04:11:31PM -0400, Naoya Horiguchi wrote:
> clear_refs_write() has some prechecks to determine if we really walk over
> a given vma. Now we have a test_walk() callback to filter vmas, so let's
> utilize it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
