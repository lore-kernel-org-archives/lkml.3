Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaHOQ43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:56:29 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56175 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaHOQ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:56:24 -0400
Message-ID: <53EE3BB3.8040800@gmail.com>
Date: Sat, 16 Aug 2014 01:56:19 +0900
From: Seunghun Lee <waydi1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>
Subject: Re: [PATCH] staging: dgnc: remove DPR Macros and related codes.
References: <1407850214-3678-1-git-send-email-waydi1@gmail.com> <20140815060841.GA28534@kroah.com>
In-Reply-To: <20140815060841.GA28534@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/15/2014 03:08 PM, Greg KH wrote:
> On Tue, Aug 12, 2014 at 10:30:14PM +0900, Seunghun Lee wrote:
>> In dgnc_drivers.h, DPR macro and DPR_* macros are defined but do nothing.
>>
>> So remove them and related codes.
>>
>> CC: Lidza Louina <lidza.louina@gmail.com>
>> CC: Mark Hounschell <markh@compro.net>
>> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
>> ---
>>  drivers/staging/dgnc/dgnc_cls.c    |   63 +--------
>>  drivers/staging/dgnc/dgnc_driver.c |   20 +--
>>  drivers/staging/dgnc/dgnc_driver.h |   21 ---
>>  drivers/staging/dgnc/dgnc_mgmt.c   |   23 ----
>>  drivers/staging/dgnc/dgnc_neo.c    |  104 ++-------------
>>  drivers/staging/dgnc/dgnc_tty.c    |  249 +++---------------------------------
>>  6 files changed, 36 insertions(+), 444 deletions(-)
> This conflicts with patches others have sent, can you refresh it after
> next Tuesday or so when I catch up with the pending patches and can push
> them out?
>
> thanks,
>
> greg k-h
Ok, I will refresh it after next Tuesday.

Thanks.
