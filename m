Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaJPTXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:23:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaJPTXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:23:16 -0400
Date: Thu, 16 Oct 2014 12:23:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH -mm v6 00/13] pagewalk: improve vma handling, apply to
 new users
Message-Id: <20141016122315.6e1b300596f74b49b8a5e36f@linux-foundation.org>
In-Reply-To: <20141016145106.GA22351@node.dhcp.inet.fi>
References: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<20141016145106.GA22351@node.dhcp.inet.fi>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 17:51:06 +0300 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Fri, Aug 01, 2014 at 03:20:36PM -0400, Naoya Horiguchi wrote:
> > This series is ver.6 of page table walker patchset.
> > I just rebased this onto mmotm-2014-07-30-15-57 with no major change.
> > Trinity shows no bug at least in my environment.
> 
> Andrew, is there any reason why the patchset is not yet applied?

Not really, just timing.  The v2 series was a bit of a disaster so I'd
want to give a new series quiet a long testing period to get it shaken
down.

