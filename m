Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbbAPViX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 16:38:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbbAPViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 16:38:22 -0500
Date: Fri, 16 Jan 2015 13:38:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm v7 00/13] pagewalk: improve vma handling, apply to
 new users
Message-Id: <20150116133820.ab5754f94201697fae3cefcc@linux-foundation.org>
In-Reply-To: <20150116163217.GA509@node.dhcp.inet.fi>
References: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<20150116163217.GA509@node.dhcp.inet.fi>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 18:32:17 +0200 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Fri, Nov 07, 2014 at 07:01:51AM +0000, Naoya Horiguchi wrote:
> > This series is ver.7 of page table walker patchset.
> > 
> > I apologize about my long delay since previous version (I have moved to
> > Japan last month and no machine access for a while.)
> > I just rebased this onto mmotm-2014-11-05-16-01. I had some conflicts but
> > the resolution was not hard.
> > Trinity showed no bug at least in my environment.
> 
> Andrew, any chance you'll find time for the patchset?
> 

That was 2+ months ago - the patches have decayed somewhat.  I'm only
seeing a few rejects so I'll have a play with them, see how it all
looks.


