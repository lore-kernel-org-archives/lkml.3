Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbbA0MPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:15:48 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:54522 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbA0MPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:15:44 -0500
Message-ID: <54C7816A.8050800@ahsoftware.de>
Date: Tue, 27 Jan 2015 13:15:38 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de> <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com> <54C77E69.7050600@ahsoftware.de> <20150127120855.GA9254@pd.tnic>
In-Reply-To: <20150127120855.GA9254@pd.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 13:08 schrieb Borislav Petkov:
> On Tue, Jan 27, 2015 at 01:02:49PM +0100, Alexander Holler wrote:
>> Look at the source at the message which is printed just before and decide
>> which one you find more informational / useful.
>
> I find such a message absolutely useless. Also, if it flies off and
> printk buffer gets overwritten, it serves you sh*t. IOW, listen to what
> Richard tells you.

Ok. I shut/give up.

Maybe you could be so nice to inform me where the similiar detail is 
exposed in sysfs for SSDs.

Also it's unlikely I will send any further patch. There are still 21 
from me where I've exposed sysfs attributes for NAND devices which are 
still not applied and most NAND devices still don't have a sysfs entry.

So why should I waste my time again?

Alexander Holler

