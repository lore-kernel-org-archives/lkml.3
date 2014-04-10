Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323AbaDJOim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:38:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177AbaDJOik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:38:40 -0400
Date: Thu, 10 Apr 2014 10:37:34 -0400
From: Dave Jones <davej@redhat.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: mm: kernel BUG at mm/huge_memory.c:1829!
Message-ID: <20140410143734.GA939@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bob Liu <lliubbo@gmail.com>, Sasha Levin <sasha.levin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Vlastimil Babka <vbabka@suse.cz>
References: <53440991.9090001@oracle.com>
 <CAA_GA1d_boVA67EBK5Rv7_F_8pb_5rBA10WB9ooCdjON93C03w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA_GA1d_boVA67EBK5Rv7_F_8pb_5rBA10WB9ooCdjON93C03w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 04:45:58PM +0800, Bob Liu wrote:
 > On Tue, Apr 8, 2014 at 10:37 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
 > > Hi all,
 > >
 > > While fuzzing with trinity inside a KVM tools guest running the latest -next
 > > kernel, I've stumbled on the following:
 > >
 > 
 > Wow! There are so many huge memory related bugs recently.
 > AFAIR, there were still several without fix. I wanna is there any
 > place can track those bugs instead of lost in maillist?
 > It seems this link is out of date
 > http://codemonkey.org.uk/projects/trinity/bugs-unfixed.php
 
It got to be too much for me to track tbh.
Perhaps this is one of the cases where using bugzilla.kernel.org might
be a useful thing ?

	Dave

