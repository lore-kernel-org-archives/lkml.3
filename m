Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbaLDPNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:13:32 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33263 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaLDPNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:13:31 -0500
MIME-Version: 1.0
In-Reply-To: <12630889.EI0exeDoNc@wuerfel>
References: <1417703910-2474-1-git-send-email-prabhakar.csengg@gmail.com> <12630889.EI0exeDoNc@wuerfel>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 4 Dec 2014 15:13:00 +0000
Message-ID: <CA+V-a8vH9McTLVSWhQZun04AP7SZ7wGHeobBK1hA+EKn5fYgKw@mail.gmail.com>
Subject: Re: [PATCH] misc: suppress build warning
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 2:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 04 December 2014 14:38:30 Lad, Prabhakar wrote:
>> this patch fixes following build warning:
>>
>> drivers/misc/ioc4.c: In function ‘ioc4_probe’:
>> drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>   period = (end - start) /
>>                 ^
>> drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
>>   uint64_t start, end, period;
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Please explain why the compiler thinks there is a bug, why you
> are sure that there isn't, and why you picked '0' as the
> initialization value.
>
Its a false positive, to suppress the warning '0' was picked.

Thanks,
--Prabhakar Lad
