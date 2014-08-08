Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaHHUcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:32:05 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:40519 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaHHUb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:31:59 -0400
Message-ID: <53E533B1.4020306@ahsoftware.de>
Date: Fri, 08 Aug 2014 22:31:45 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: Alexander Shiyan <shc_work@mail.ru>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/27] mtd: nand: pxa3xx: show device structure in sysfs
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de> <1401142372-14148-10-git-send-email-holler@ahsoftware.de> <1401160341.192042842@f271.i.mail.ru> <20140808170428.GA6094@arch.cereza> <20140808171650.GS3711@ld-irv-0074> <20140808181157.GA16575@arch.cereza>
In-Reply-To: <20140808181157.GA16575@arch.cereza>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.08.2014 20:11, schrieb Ezequiel Garcia:
> On 08 Aug 10:16 AM, Brian Norris wrote:
>> On Fri, Aug 08, 2014 at 02:04:28PM -0300, Ezequiel Garcia wrote:
>
>>> If there's anything left to fix for this driver, please let me know.
>>
>> pxa3xx_nand is still missing a parent for its MTD's (mtd->dev.parent). I
>> have a follow-up patch queued up locally that I need to send out
>> sometime.
>>
>
> Maybe we can trade... you provide the reason for such parent, and I'll cook
> a patch in exchange :)

Just read the subject.and the introductory mail to the simple 20+ 
pathches I wasted my time with.

Regards,

Alexander Holler
