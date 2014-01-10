Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbaAJRAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:00:44 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:53625 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967AbaAJRAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:00:40 -0500
Date: Fri, 10 Jan 2014 19:00:16 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: kernel BUG at mm/huge_memory.c:1440!
Message-ID: <20140110170016.GA5179@node.dhcp.inet.fi>
References: <52B88F6E.8070909@oracle.com>
 <20131223200255.GA18521@node.dhcp.inet.fi>
 <52B8AAFD.5090401@oracle.com>
 <52C819E2.8090509@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C819E2.8090509@oracle.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 09:25:38AM -0500, Sasha Levin wrote:
> On 12/23/2013 04:28 PM, Sasha Levin wrote:
> >On 12/23/2013 03:02 PM, Kirill A. Shutemov wrote:
> >>>[  265.474585] kernel BUG at mm/huge_memory.c:1440!
> >>Could you dump_page() on the bug?
> >
> >[  469.007946] page:ffffea0005bd8000 count:3 mapcount:0 mapping:ffff8800bcd3d171 index: 0x7fca81000
> >[  469.009362] page flags: 0x2afffff80090018(uptodate|dirty|swapcache|swapbacked)
> 
> Ping? It still shows up in 3.13-rc6.

Sorry, I don't have a theory why it can happen. And I can't reproduce it.

Is there chance to get trinity log after the crash?

-- 
 Kirill A. Shutemov
