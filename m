Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3GZGDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 02:03:08 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:61729 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab3GZGDE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 02:03:04 -0400
MIME-Version: 1.0
In-Reply-To: <1374749544.29835.50.camel@x61.thuisdomein>
References: <alpine.DEB.2.02.1307251458330.31610@M2420>
	<1374749544.29835.50.camel@x61.thuisdomein>
Date: Fri, 26 Jul 2013 14:03:02 +0800
Message-ID: <CADJHv_s+37Y1BLJaei1rY=JLXfej7BOrMFLG0U-sLmikhGxXtg@mail.gmail.com>
Subject: Re: [PATCH] staging/lustre: add BLOCK depends in Kconfig
From: Xiong Zhou <jencce.kernel@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/25 Paul Bolle <pebolle@tiscali.nl>:
> On Thu, 2013-07-25 at 15:06 +0800, Xiong Zhou wrote:
>> Add BLOCK depends in Kconfig for LUSTRE to fix this:
>> drivers/staging/lustre/lustre/fid/../include/linux/lustre_compat25.h:117:2:
>> error: implicit declaration of function ‘unregister_blkdev’
>>
>> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
>> ---
>>  drivers/staging/lustre/lustre/Kconfig |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
>> index 9ae7fa8..0b45de0 100644
>> --- a/drivers/staging/lustre/lustre/Kconfig
>> +++ b/drivers/staging/lustre/lustre/Kconfig
>> @@ -1,6 +1,6 @@
>>  config LUSTRE_FS
>>         tristate "Lustre file system client support"
>> -       depends on STAGING && INET && m
>> +       depends on STAGING && INET && BLOCK && m
>
> Everything below drivers/staging/lustre/Kconfig is only sourced if
> STAGING is set. You can drop the dependency on STAGING.
>

Yes, it is. Thanks~

>>         select LNET
>>         select CRYPTO
>>         select CRYPTO_CRC32
>
>
> Paul Bolle
>
