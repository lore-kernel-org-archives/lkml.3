Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3FQV3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:29:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3FQV3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:29:16 -0400
Date: Mon, 17 Jun 2013 14:29:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: +
 mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch added to -mm
 tree
Message-Id: <20130617142914.4914dcfbd19d345dde686245@linux-foundation.org>
In-Reply-To: <20130617132746.GA30262@shutemov.name>
References: <20130513231406.D912031C276@corp2gmr1-1.hot.corp.google.com>
	<20130617132746.GA30262@shutemov.name>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 16:27:46 +0300 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Mon, May 13, 2013 at 04:14:06PM -0700, akpm@linux-foundation.org wrote:
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > Subject: mm/THP: don't use HPAGE_SHIFT in transparent hugepage code
> > 
> > For architectures like powerpc that support multiple explicit hugepage
> > sizes, HPAGE_SHIFT indicate the default explicit hugepage shift.  For THP
> > to work the hugepage size should be same as PMD_SIZE.  So use PMD_SHIFT
> > directly.  So move the define outside CONFIG_TRANSPARENT_HUGEPAGE #ifdef
> > because we want to use these defines in generic code with if
> > (pmd_trans_huge()) conditional.
> 
> I would propose to partly revert the patch with the patch bellow.

It's not completely clear what you're proposing here.  Can you send a
real patch against mmotm or -next for us to look at?

