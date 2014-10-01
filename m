Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaJAVLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaJAVLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:11:40 -0400
Message-ID: <542C6D86.70902@redhat.com>
Date: Wed, 01 Oct 2014 17:09:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
CC: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: pipe/page fault oddness.
References: <20140930033327.GA14558@redhat.com>	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>	<20140930043309.GA16196@redhat.com>	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>	<20140930160510.GA15903@redhat.com>	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>	<20140930162201.GC15903@redhat.com>	<20140930164047.GA18354@redhat.com>	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>	<20140930182059.GA24431@redhat.com>	<CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>	<alpine.LSU.2.11.1410010031070.1902@eggly.anvils>	<CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>	<CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com> <CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>
In-Reply-To: <CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 04:20 PM, Linus Torvalds wrote:

> Now, I'll be honest: this patch *migth* just work, but I expect it to
> have some stupid problem. It compiles. I haven't even dared boot it,
> much less try any numa benchmarks that woudln't show anything sane on
> my machine anyway.
> 
> So I'm really sending this patch out in the hope that it will get
> comments, fixup and possibly even testing by people who actually know
> the NUMA balancing code. Rik?  Anybody?

I'll add it to the list. No guarantees I'll be able to get
to it before Linux Con / KVM Forum though. I have a bit of
a backlog to get through this coming week...

