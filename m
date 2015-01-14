Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbbANOss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:48:48 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:57031 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbbANOsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:48:46 -0500
Date: Wed, 14 Jan 2015 17:48:43 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] mm: rename mm->nr_ptes to mm->nr_pgtables
Message-ID: <20150114144843.GE2253@moon>
References: <1421176456-21796-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1421176456-21796-2-git-send-email-kirill.shutemov@linux.intel.com>
 <20150113214355.GC2253@moon>
 <54B592D6.4090406@linux.intel.com>
 <20150114094538.GD2253@moon>
 <20150114143358.GA9820@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114143358.GA9820@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 04:33:58PM +0200, Kirill A. Shutemov wrote:
> > 
> > It looks like this doesn't matter. The statistics here prints the size
> > of summary memory occupied for pte_t entries, here PTRS_PER_PTE * sizeof(pte_t)
> > is only valid for, once we start accounting pmd into same counter it implies
> > that PTRS_PER_PTE == PTRS_PER_PMD, which is not true for all archs
> > (if I understand the idea of accounting here right).
> 
> Yeah. good catch. Thank you.
> 
> I'll respin with separate counter for pmd tables. It seems the best
> option.

Sounds good to me, thanks.
