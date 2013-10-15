Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab3JORyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:54:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16715 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab3JORyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:54:32 -0400
Message-ID: <525D8130.1070807@oracle.com>
Date: Tue, 15 Oct 2013 12:53:52 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, linux-aio@kvack.org
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com> <20130821130231.GG13330@kvack.org> <20131014150701.GA21529@infradead.org> <20131014212910.GA31920@kvack.org> <20131015165520.GA13021@infradead.org> <20131015171447.GE31920@kvack.org> <20131015171850.GA26277@infradead.org>
In-Reply-To: <20131015171850.GA26277@infradead.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 12:18 PM, Christoph Hellwig wrote:
> On Tue, Oct 15, 2013 at 01:14:47PM -0400, Benjamin LaHaise wrote:
>>> While I agree that getting that would be useful it is something that has
>>> nothing to do with issueing aio from kernel space and holding this
>>> patchset hostage for something you'd like to see but that was
>>> complicated enough that no one even tried it for many years seems
>>> entirely unreasonable.
>>>
>>> If there are any other issues left that I have missed it would be nice
>>> to get a pointer to it, or a quick brief.
>>
>> The item I was refering to is to removing the opcodes used for in-kernel 
>> purposes from out of the range that the userland accessible opcodes can 
>> reach.  That is, put them above the 16 bit limit for userspace opcodes.  
>> There is absolutely no reason to expose kernel internal opcodes via the 
>> userspace exported includes.  It's a simple and reasonable change, and I 
>> see no reason for Dave not to make that modification.  Until that is 
>> done, I will nak the changes.
> 
> Oh, missed that.  I totally agree that it needs to be done.
> 
> Dave, will you have time to do it soon or should I look into it myself?

I'll take care of it. I actually made this change and somehow misplaced it.

Sorry about that.

Dave
