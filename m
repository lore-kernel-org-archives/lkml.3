Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3IXT3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:29:51 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61257 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3IXT3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:29:49 -0400
MIME-Version: 1.0
In-Reply-To: <5241CB44.8080004@ahsoftware.de>
References: <20130923090100.GE6192@mwanda>
	<CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com>
	<5241CB44.8080004@ahsoftware.de>
Date: Tue, 24 Sep 2013 21:29:49 +0200
Message-ID: <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com>
Subject: Re: checkpatch guide for newbies
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 7:26 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 24.09.2013 18:36, schrieb Bjorn Helgaas:
>>
>> On Mon, Sep 23, 2013 at 3:01 AM, Dan Carpenter <dan.carpenter@oracle.com>
>> wrote:
>>>
>>>                  Long Lines
>>>
>>> Historically screens were 80 characters wide and it was annoying when
>>> code went
>>> over the edge.  These days we have larger screens, but we keep the 80
>>> character
>>> limit because it forces us to write simpler code.
>
>
> Sorry, but that just isn't true and never was. Having a line wide limit of
> 80 characters while forcing tabs to be 8 characters long limits most code to
> just 72 characters. And even less (max 64) inside constructs like if, for or
> while.
>
> The only outcome of that totally silly rule is that variable names will
> become shorted to silly acronyms almost nobody does understand make code
> unreadable.
>
> I always feel like beeing in the IT stone age when programmers thought they
> have to use variable names like a, b and c to save storage, memory or to
> type less when reading linux kernel code.
I was about to disagree because I've never seen variables named a, b
or c, but I found that there are at least 2238 variables named a, b or
c in linux-next. This is not good.

>
> Regards,
>
> Alexander Holler
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Peter
