Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3IXSvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:51:16 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51825 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab3IXSvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:51:14 -0400
Message-ID: <5241DEEF.5060509@ahsoftware.de>
Date: Tue, 24 Sep 2013 20:50:23 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
References: <20130923090100.GE6192@mwanda> <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com> <5241CB44.8080004@ahsoftware.de> <5241CF3C.8040403@ahsoftware.de>
In-Reply-To: <5241CF3C.8040403@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.09.2013 19:43, schrieb Alexander Holler:
> Am 24.09.2013 19:26, schrieb Alexander Holler:
>> Am 24.09.2013 18:36, schrieb Bjorn Helgaas:
>>> On Mon, Sep 23, 2013 at 3:01 AM, Dan Carpenter
>>> <dan.carpenter@oracle.com> wrote:
>>>>                  Long Lines
>>>>
>>>> Historically screens were 80 characters wide and it was annoying when
>>>> code went
>>>> over the edge.  These days we have larger screens, but we keep the 80
>>>> character
>>>> limit because it forces us to write simpler code.
>>
>> Sorry, but that just isn't true and never was. Having a line wide limit
>> of 80 characters while forcing tabs to be 8 characters long limits most
>> code to just 72 characters. And even less (max 64) inside constructs
>> like if, for or while.
>>
>> The only outcome of that totally silly rule is that variable names will
>> become shorted to silly acronyms almost nobody does understand make code
>> unreadable.
>
> I forgot to mention function names, which are often even worse shortened
> than variable names.
>
>>
>> I always feel like beeing in the IT stone age when programmers thought
>> they have to use variable names like a, b and c to save storage, memory
>> or to type less when reading linux kernel code.

Just in case of ...

It isn't my intention to start a discussion about that 80 character 
limit, but justifying it with wrong arguments shouldn't be done.

You could write "'It's there and you have to live with it.", but trying 
to justify it with obviously wrong arguments should not be done.

Code doesn't get more simple by forcing people to use akronymous, 
abrevations or to split lines.

Regards,

Alexander Holler

