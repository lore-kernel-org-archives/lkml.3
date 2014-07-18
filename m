Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761831AbaGRQG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:06:59 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:56525 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbaGRQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:06:58 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1399139966-10625-1-git-send-email-peter@piie.net> <1399139966-10625-3-git-send-email-peter@piie.net> <20140717094648.GB23869@pd.tnic>
Message-ID: <cone.1405699613.361414.1043.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v3 2/6] acerhdf: Adding support for new models
Date: Fri, 18 Jul 2014 18:06:53 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov writes:

> On Sat, May 03, 2014 at 07:59:22PM +0200, Peter Feuerer wrote:
>> added following new models:
>>    * Aspire 5755G
>>    * AO521
>>    * AO751h
>>    * Aspire One 753
>>    * Extensa 5420
>>    * Aspire 5315
>>    * Aspire 5739G
>>    * TravelMate TM8573T
>> 
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andreas Mohr <andi@lisas.de>
>> Cc: Borislav Petkov <bp@suse.de>
>> Signed-off-by: Peter Feuerer <peter@piie.net>
> 
> Acked-by: Borislav Petkov <bp@suse.de>
> 
>> ---
>>  drivers/platform/x86/acerhdf.c | 25 ++++++++++++++++++++++++-
>>  1 file changed, 24 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
>> index dd63e93..176edbd 100644
>> --- a/drivers/platform/x86/acerhdf.c
>> +++ b/drivers/platform/x86/acerhdf.c
>> @@ -50,7 +50,7 @@
>>   */
>>  #undef START_IN_KERNEL_MODE
>>  
>> -#define DRV_VER "0.5.29"
>> +#define DRV_VER "0.5.30"
> 
> What's the logic here, increment second minor version number after each
> change?

Everytime I send out a modified version of acerhdf.c to someone in the 
internet for trying out some changes, I increment the second minor version 
number.  And from time to time I push things to Mainline, then I need to 
catch up with the numbering ;)

The major 0 is just from the ages, when all cool projects used to have a 
0 in front.

Maybe it would be a good idea to go for 1.0 when I implemented a better
handling for the huge bios table.

-- 
--peter;
