Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaBNN3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:29:41 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751792AbaBNN3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:29:40 -0500
Message-ID: <52FE1A3A.9090301@nod.at>
Date: Fri, 14 Feb 2014 14:29:30 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
References: <20140212040358.GA25327@redhat.com> <20140212042215.GN18016@ZenIV.linux.org.uk> <20140212054043.GB13997@dastard> <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com> <20140212113928.GO18016@ZenIV.linux.org.uk> <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com> <20140212211421.GP18016@ZenIV.linux.org.uk> <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com> <20140212214411.GQ18016@ZenIV.linux.org.uk> <20140213205146.GS18016@ZenIV.linux.org.uk> <20140214132503.GA23265@infradead.org>
In-Reply-To: <20140214132503.GA23265@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.02.2014 14:25, schrieb Christoph Hellwig:
> On Thu, Feb 13, 2014 at 08:51:46PM +0000, Al Viro wrote:
>> On Wed, Feb 12, 2014 at 09:44:11PM +0000, Al Viro wrote:
>>
>>> I'll try to put something along those lines together, if you or Oleg don't
>>> do it first.
>>
>> OK, having looked at that stuff...
>>
>> 1) things become much more compact if we finish conversion to get_signal()
>> first.
> 
> I have vague memories that Richard sent out a series to convert over all
> architectures a while ago.  Hopefully he has better memory than I do.

Yeah. Sending v2 of that series is on my overflowing TODO list. :-\
I think this is a good reason for me to start working on that series again.
Stay tuned.

Thanks,
//richard

