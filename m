Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaCKGCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:02:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:23613 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaCKGCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:02:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="495939204"
Message-ID: <531EA70A.2070304@linux.intel.com>
Date: Mon, 10 Mar 2014 23:02:50 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: stefani@seibold.net
CC: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
References: <20140307013833.GD8427@localhost> <1394176888.1018.3.camel@wall-e.seibold.net> <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com> <1394229220.20013.13.camel@wall-e.seibold.net> <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com> <1394354848.1002.37.camel@wall-e.seibold.net> <531D044C.2090303@linux.intel.com> <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com> <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com> <531DD35A.5060202@linux.intel.com> <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com> <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com> <1394481804.980.9.camel@wall-e.seibold.net> <531E1B53.5090205@linux.intel.com> <20140310222900.Horde.v9U-wjSperyf8zRvwBVchw8@webmail.your-server.de>
In-Reply-To: <20140310222900.Horde.v9U-wjSperyf8zRvwBVchw8@webmail.your-server.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 02:29 PM, stefani@seibold.net wrote:
> 
> Do you except a complete new patch set or an incremental patch based on the
> current patch set?
> 

An incremental patch is probably easier.

	-hpa


