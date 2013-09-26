Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3IZCxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:53:49 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35286 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3IZCxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:53:48 -0400
Message-ID: <5243A165.2060204@ahsoftware.de>
Date: Thu, 26 Sep 2013 04:52:21 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
References: <20130923090100.GE6192@mwanda> <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com> <5241CB44.8080004@ahsoftware.de> <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com> <CAErSpo4X0-PEYtZrY2r4GKmzTJhHK3eKdXrbccJhB7wVkVCYLA@mail.gmail.com> <52420DF1.7060108@ahsoftware.de> <20130926021130.GD13318@ZenIV.linux.org.uk>
In-Reply-To: <20130926021130.GD13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 04:11, schrieb Al Viro:
> On Wed, Sep 25, 2013 at 12:10:57AM +0200, Alexander Holler wrote:
> 
>> Sure and I'm the last one who wants that people do have to use
>> anything else than i for simple loop counters. And allowing longer
>> lines doesn't mean people have to use long names, it allows them use
>> them (if it makes sense). That's a big difference.
>>
>> On the other side it's almost impossible to use verbose variable or
>> function names where they would make sense. Not to speak about all
>> the ugly splitted lines just to be below that ancient CGA limit.
> 
> Yeah, the things people will do to avoid <gasp> not nesting the living
> hell out of their code...
> 
> Tell you what - pick a random place where the code is nested 8 levels
> deep and I'm fairly sure that you will end up with your finger on one
> hell of ugliness.  Ugliness in logical structure, not in forced line
> breaks.  Let's experiment...  Aha.  In drivers/pci/hotplug/ibmphp_pci.c,
> 258 lines of deeply indented shite^Wcode that must be good since it compiles:
> 
> <avert your eyes if you've got a weak stomach>

I'm aware of people which do nest 8 levels deep just to avoid a return,
break or goto.

But trying to limit that by limiting the line length is like ...
(choose your own own misguided comparison, it's too late for me I
currently only meorize some of those which don't make sense in english)

Regards,

Alexander Holler

