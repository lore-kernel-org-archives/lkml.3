Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaF3MIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:08:52 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:33921 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbaF3MIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:08:49 -0400
Date: Mon, 30 Jun 2014 15:08:37 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v3 08/13] numa_maps: fix typo in gather_hugetbl_stats
Message-ID: <20140630120837.GX19833@node.dhcp.inet.fi>
References: <1403295099-6407-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1403295099-6407-9-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403295099-6407-9-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 04:11:34PM -0400, Naoya Horiguchi wrote:
> Just doing s/gather_hugetbl_stats/gather_hugetlb_stats/g, this makes code
> grep-friendly.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
