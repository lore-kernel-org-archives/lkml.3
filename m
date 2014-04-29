Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbaD2MID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933447AbaD2MIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:08:01 -0400
Message-ID: <535F95FC.1020909@redhat.com>
Date: Tue, 29 Apr 2014 08:07:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Randy Dunlap <rdunlap@infradead.org>
CC: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
References: <535992DD.3060808@infradead.org> <20140425100459.7824f676@annuminas.surriel.com> <535AC91A.1070504@infradead.org> <535ACB0E.4070600@infradead.org> <20140427062650.GW4496@linux.vnet.ibm.com> <20140428135540.GA14661@linux.vnet.ibm.com> <535E8D14.7080405@infradead.org> <535E8E17.2050600@nod.at> <20140428200640.GG4430@linux.vnet.ibm.com> <535EBAE6.3080907@infradead.org> <20140428211535.GK4430@linux.vnet.ibm.com>
In-Reply-To: <20140428211535.GK4430@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 05:15 PM, Paul E. McKenney wrote:
> On Mon, Apr 28, 2014 at 01:32:38PM -0700, Randy Dunlap wrote:
>> On 04/28/14 13:06, Paul E. McKenney wrote:

>>> Please see below for a patch against next-20140428 that makes this build
>>> for me.  This is derived from Rik's patch, my patch, and is consistent with
>>> Arnd's patch.
>>>
>>> 							Thanx, Paul
>>
>> Thnx, works for me.  Finally.
> 
> Good!
> 
> Rik, how would you like to proceed with this?

I guess this fix should go into -mm?

-- 
All rights reversed
