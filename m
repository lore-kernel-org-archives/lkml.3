Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaLCWbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:31:31 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46548 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaLCWb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:31:27 -0500
MIME-Version: 1.0
In-Reply-To: <20141203221307.GC14524@fuloong-minipc.musicnaut.iki.fi>
References: <1417643031-26190-1-git-send-email-jamie.lawler@gmail.com> <20141203221307.GC14524@fuloong-minipc.musicnaut.iki.fi>
From: Jamie Lawler <jamie.lawler@gmail.com>
Date: Wed, 3 Dec 2014 22:31:05 +0000
Message-ID: <CABnVuT=xzw_i+Z=1qo_4ZYz1TQCoJJ-SsheFo1C17X1NBkqs1w@mail.gmail.com>
Subject: Re: [PATCH] Staging: octeon: Added several blank lines after declarations
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Aaro, I will do that now.

Jamie

On 3 December 2014 at 22:13, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> Hi,
>
> On Wed, Dec 03, 2014 at 09:43:51PM +0000, Jamie Lawler wrote:
>> --- a/drivers/staging/octeon/ethernet-rx.c
>> +++ b/drivers/staging/octeon/ethernet-rx.c
>> @@ -84,6 +84,7 @@ static int cvm_irq_cpu;
>>  static void cvm_oct_enable_napi(void *_)
>>  {
>>       int cpu = smp_processor_id();
>> +
>>       napi_schedule(&cvm_oct_napi[cpu].napi);
>>  }
>
> This function has already been deleted from the staging tree.
> You need to refresh your patch and see if it's still relevant for
> the current tree.
>
> A.
