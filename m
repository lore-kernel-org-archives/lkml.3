Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbbA0Mo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:44:27 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:56318 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbbA0MoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:44:22 -0500
Message-ID: <54C7881F.6020501@ahsoftware.de>
Date: Tue, 27 Jan 2015 13:44:15 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Borislav Petkov <bp@alien8.de>
CC: linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de> <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com> <54C77E69.7050600@ahsoftware.de> <20150127120855.GA9254@pd.tnic> <54C7816A.8050800@ahsoftware.de> <54C78524.3070901@nod.at>
In-Reply-To: <54C78524.3070901@nod.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 13:31 schrieb Richard Weinberger:

>> Also it's unlikely I will send any further patch. There are still 21 from me where I've exposed sysfs attributes for NAND devices which are still not applied and most NAND devices
>> still don't have a sysfs entry.
>>
>> So why should I waste my time again?
>
> If you give up after the first review round there is nothing I can do for you.
> Postings like https://lkml.org/lkml/2014/5/30/162 are also not really beneficial
> to get a patch merged.

Yes. Sorry, but I had so many bad experiences with maintainers. They 
told me that using functions means hiding stuff, that I should bisect 
even when I was absolutely sure which patch was wrong (and everxyone 
could see it by just reading the source and by reading my comments, I've 
got blamed because I prefer a controlled BUG_ON() (which might even just 
kill the involved tasks, depending on config settings) instead of a 
desastrous memory corruption which (hard-) reseted the machine (and 
might have done even more bad things) and so on.

Regards,

Alexander Holler
