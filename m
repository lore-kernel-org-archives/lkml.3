Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbbA0Mbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:31:40 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbbA0Mbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:31:35 -0500
Message-ID: <54C78524.3070901@nod.at>
Date: Tue, 27 Jan 2015 13:31:32 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>, Borislav Petkov <bp@alien8.de>
CC: linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de> <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com> <54C77E69.7050600@ahsoftware.de> <20150127120855.GA9254@pd.tnic> <54C7816A.8050800@ahsoftware.de>
In-Reply-To: <54C7816A.8050800@ahsoftware.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 13:15 schrieb Alexander Holler:
> Am 27.01.2015 um 13:08 schrieb Borislav Petkov:
>> On Tue, Jan 27, 2015 at 01:02:49PM +0100, Alexander Holler wrote:
>>> Look at the source at the message which is printed just before and decide
>>> which one you find more informational / useful.
>>
>> I find such a message absolutely useless. Also, if it flies off and
>> printk buffer gets overwritten, it serves you sh*t. IOW, listen to what
>> Richard tells you.
> 
> Ok. I shut/give up.

There is no need to be sulky.

> Maybe you could be so nice to inform me where the similiar detail is exposed in sysfs for SSDs.

If it is not already exposed and you can come up with a sane use case send a patch.

> Also it's unlikely I will send any further patch. There are still 21 from me where I've exposed sysfs attributes for NAND devices which are still not applied and most NAND devices
> still don't have a sysfs entry.
> 
> So why should I waste my time again?

If you give up after the first review round there is nothing I can do for you.
Postings like https://lkml.org/lkml/2014/5/30/162 are also not really beneficial
to get a patch merged.

Thanks,
//richard

P.s. If you see every not-merged patch as a waste of time, please stop developing software as
it is obviously not an enjoyment for you.
