Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaJPOva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:51:30 -0400
Received: from mta-out1.inet.fi ([62.71.2.226]:40183 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaJPOv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:51:29 -0400
Date: Thu, 16 Oct 2014 17:51:06 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH -mm v6 00/13] pagewalk: improve vma handling, apply to
 new users
Message-ID: <20141016145106.GA22351@node.dhcp.inet.fi>
References: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 03:20:36PM -0400, Naoya Horiguchi wrote:
> This series is ver.6 of page table walker patchset.
> I just rebased this onto mmotm-2014-07-30-15-57 with no major change.
> Trinity shows no bug at least in my environment.

Andrew, is there any reason why the patchset is not yet applied?
I have some code on top of the patchset and it would be easier for me if
the patchset get to -mm.

-- 
 Kirill A. Shutemov
