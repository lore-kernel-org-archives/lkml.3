Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaBUCQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:16:14 -0500
Received: from mail-qc0-f195.google.com ([209.85.216.195]:64892 "EHLO
	mail-qc0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaBUCQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:16:12 -0500
MIME-Version: 1.0
In-Reply-To: <530564A1.50708@samsung.com>
References: <1392817677-4755-1-git-send-email-yix.x.zhang@gmail.com>
	<530564A1.50708@samsung.com>
Date: Fri, 21 Feb 2014 10:16:11 +0800
Message-ID: <CAAP1=Nk4ppcmMhQ8b6QzT3AQG1cSExfVpmk=6Duun9HhOb1wuA@mail.gmail.com>
Subject: Re: [PATCH] Add eMMC 5.0 support
From: =?GB2312?B?1cXS4w==?= <yix.x.zhang@gmail.com>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, I missed this mail, thanks

2014-02-20 10:12 GMT+08:00 Jaehoon Chung <jh80.chung@samsung.com>:
> Hi,
>
> You can refer to this.
>
> http://comments.gmane.org/gmane.linux.kernel.mmc/23838
>
> Best Regards,
> Jaehoon Chung
>
> On 02/19/2014 10:47 PM, Zhang Yi wrote:
>> Current code will exist when read eMMC 5.0, add support for it
>>
>> Signed-off-by: Zhang Yi <yix.x.zhang@gmail.com>
>> ---
>>  mmc_cmds.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/mmc_cmds.c b/mmc_cmds.c
>> index b8afa74..5edf42b 100644
>> --- a/mmc_cmds.c
>> +++ b/mmc_cmds.c
>> @@ -722,6 +722,9 @@ int do_read_extcsd(int nargs, char **argv)
>>       ext_csd_rev = ext_csd[192];
>>
>>       switch (ext_csd_rev) {
>> +     case 7:
>> +             str = "5.0";
>> +             break;
>>       case 6:
>>               str = "4.5";
>>               break;
>>
>
