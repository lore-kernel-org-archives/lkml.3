Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaCJW7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:59:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53980 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaCJW7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:59:47 -0400
Message-ID: <531E43B8.7090302@zytor.com>
Date: Mon, 10 Mar 2014 15:59:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at d34bd000
References: <531D044C.2090303@linux.intel.com> <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com> <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com> <531DD35A.5060202@linux.intel.com> <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com> <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com> <1394481804.980.9.camel@wall-e.seibold.net> <531E1B53.5090205@linux.intel.com> <CA+55aFyxbuhPKgB=U8R5C5T_iKVvju-oQDS4kHz6McW45B+1bA@mail.gmail.com> <CA+55aFwuVYds=ssv755WKBvux1ru6fcDLGi+ORSFyU8xYP7+=w@mail.gmail.com> <20140310215111.GA27749@redhat.com>
In-Reply-To: <20140310215111.GA27749@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 02:51 PM, Dave Jones wrote:
> 
> Even when it worked, it was only a small performance increase anyway,
> 

If it is performance rather then correctness, then let's kill it now.

I'd love to push that patchset already for 3.15, anyone want to write it
up (I'm on a trip)... otherwise I'll do it Wednesday or so.

	-hpa

