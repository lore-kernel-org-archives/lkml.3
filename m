Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbbAPQcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:32:42 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:46797 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbbAPQcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:32:41 -0500
Date: Fri, 16 Jan 2015 18:32:17 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm v7 00/13] pagewalk: improve vma handling, apply to
 new users
Message-ID: <20150116163217.GA509@node.dhcp.inet.fi>
References: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 07:01:51AM +0000, Naoya Horiguchi wrote:
> This series is ver.7 of page table walker patchset.
> 
> I apologize about my long delay since previous version (I have moved to
> Japan last month and no machine access for a while.)
> I just rebased this onto mmotm-2014-11-05-16-01. I had some conflicts but
> the resolution was not hard.
> Trinity showed no bug at least in my environment.

Andrew, any chance you'll find time for the patchset?

-- 
 Kirill A. Shutemov
