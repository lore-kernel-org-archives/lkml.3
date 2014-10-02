Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaJBTNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:13:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48658 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaJBTNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:13:37 -0400
Message-ID: <542DA3B7.8090901@oracle.com>
Date: Thu, 02 Oct 2014 15:12:55 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
References: <1412256558-9995-1-git-send-email-mgorman@suse.de> <1412256558-9995-5-git-send-email-mgorman@suse.de> <CA+55aFzJtoEXEzoyYQ=j+AMxyZNL3Gr3bhXPr3twyuGzvES1PA@mail.gmail.com> <542DA038.9000908@oracle.com> <CA+55aFwybOYtuOn43idiikVDPfBO7pWb4vLjhcM0dYUxTx7odA@mail.gmail.com> <20141002190734.GA15671@node.dhcp.inet.fi>
In-Reply-To: <20141002190734.GA15671@node.dhcp.inet.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 03:07 PM, Kirill A. Shutemov wrote:
> On Thu, Oct 02, 2014 at 12:03:58PM -0700, Linus Torvalds wrote:
>> > On Thu, Oct 2, 2014 at 11:58 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>> > >
>>> > > You've also mentioned that while I can tell you if nothing dies, I can't
>>> > > really tell you if everything is working well. Is there a reasonable way
>>> > > to easily say if NUMA is working properly? Even something that would just
>>> > > tell me "your NUMA balancing seems to be sane" would be good.
>> > 
>> > So not having a NUMA machine (and not really wanting one), I can't
>> > really test things like the migration even *working*.
> I believe Sasha uses fakenuma in his KVM for that.

That's true. You can impose arbitrary configurations on your kernel even without your
hardware telling you to...


Thanks,
Sasha
