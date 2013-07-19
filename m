Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926Ab3GSQ7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:59:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45125 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760466Ab3GSQ7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:59:02 -0400
Message-ID: <51E97029.9090500@zytor.com>
Date: Fri, 19 Jul 2013 09:58:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] How to act on LKML
References: <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com> <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos> <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com> <1373926109.17876.221.camel@gandalf.local.home> <CA+55aFwdYxfgE8B4oPVFXWTJUcnDKnM4cchZ=t08mFwEHX+TAA@mail.gmail.com> <1373999229.2148.87.camel@dabdike> <20130716211830.GX16780@linux.vnet.ibm.com> <1374041689.2036.14.camel@dabdike.svoaero.ru> <1374112865.19894.493.camel@pasglop> <20130719060343.GA16774@linux.vnet.ibm.com>
In-Reply-To: <20130719060343.GA16774@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 11:03 PM, Paul E. McKenney wrote:
>>
>> Ie. It's a *very good* barrier against maintainers sliding into
>> sloppyness. Really, it works. At least with me.
>>
>> It's easy to take things a bit too much for granted, especially when you
>> maintain your own little corner of the world.
> 
> Agreed!  Though I must confess that I have shifted from being mostly
> worried about people yelling at me to being mostly worried about my own
> code yelling at me.  Either way, I do find that being worried about some
> consequence or another does help me get a better result.
> 

Yes.  Linus' little rant from last weekend has had me and the other tip
maintainers look at process changes and new tooling, which we probably
should have done a while ago... but it just got way too buried on the
list of priorities.

	-hpa


