Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaLQTqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:46:30 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:37352 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:46:29 -0500
Message-ID: <5491DD97.6010303@gmail.com>
Date: Wed, 17 Dec 2014 13:46:31 -0600
From: Dinh Nguyen <dinh.linux@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: dinguyen@opensource.altera.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm: socfpga: Set share override bit of the l2 cache
 controller
References: <1416546280-12068-1-git-send-email-dinguyen@opensource.altera.com> <1416546280-12068-2-git-send-email-dinguyen@opensource.altera.com> <2156186.zs80uXCLAf@wuerfel>
In-Reply-To: <2156186.zs80uXCLAf@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 11/21/14, 5:04 AM, Arnd Bergmann wrote:
> On Thursday 20 November 2014 23:04:40 dinguyen@opensource.altera.com wrote:
>>
>> ---
>>  arch/arm/mach-socfpga/socfpga.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
>> index 13b1858..afc009f 100644
>> --- a/arch/arm/mach-socfpga/socfpga.c
>> +++ b/arch/arm/mach-socfpga/socfpga.c
>> @@ -105,7 +105,8 @@ static const char *altera_dt_match[] = {
>>  
>>  DT_MACHINE_START(SOCFPGA, "Altera SOCFPGA")
>>         .l2c_aux_val    = L310_AUX_CTRL_DATA_PREFETCH |
>> -                         L310_AUX_CTRL_INSTR_PREFETCH,
>> +                         L310_AUX_CTRL_INSTR_PREFETCH |
>> +                         L2C_AUX_CTRL_SHARED_OVERRIDE,
>>         .l2c_aux_mask   = ~0,
>>         .smp            = smp_ops(socfpga_smp_ops),
>>         .map_io         = socfpga_map_io,
> 
> Hi Dinh,
> 
> Please do this by putting the appropriate proterties into the
> l2x0 DT node instead.
> 

I don't see a way to do this using the l2x0 DT node.

Thanks,
Dinh
