Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3FXGns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:43:48 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41278 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3FXGnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:43:47 -0400
Message-ID: <51C7EA9C.60505@linux.vnet.ibm.com>
Date: Mon, 24 Jun 2013 12:13:40 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: mahesh@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/pseries: Enable PSTORE in pseries_defconfig
References: <20130621083639.4039.27789.stgit@aruna-ThinkPad-T420> <7684.1372036896@ale.ozlabs.ibm.com>
In-Reply-To: <7684.1372036896@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062406-8256-0000-0000-0000080D24C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Monday 24 June 2013 06:51 AM, Michael Neuling wrote:
>> Enable PSTORE in pseries_defconfig
> Please add a "why" to your changelogs eg. "Now we have pstore support for
> nvram on pseries, enable it in the default config"
>
> "Why" you are changing something is more important than "what", since
> you can always determine "what" is being changed, by looking at the diff.
> The "why" will be long forgotten.
>
>> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
>> ---
>>   arch/powerpc/configs/pseries_defconfig |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
>> index c4dfbaf..9630a50 100644
>> --- a/arch/powerpc/configs/pseries_defconfig
>> +++ b/arch/powerpc/configs/pseries_defconfig
>> @@ -347,3 +347,4 @@ CONFIG_VIRTUALIZATION=y
>>   CONFIG_KVM_BOOK3S_64=m
>>   CONFIG_KVM_BOOK3S_64_HV=y
>>   CONFIG_VHOST_NET=m
>> +CONFIG_PSTORE=y
> This should really be added in the right location on the config, not
> just at the end.   ie.

Sorry, I overlooked this commentin my v2 patch. Will resend.

> @@ -296,6 +293,7 @@
>   CONFIG_SQUASHFS_XATTR=y
>   CONFIG_SQUASHFS_LZO=y
>   CONFIG_SQUASHFS_XZ=y
> +CONFIG_PSTORE=y
>   CONFIG_NFS_FS=y
>   CONFIG_NFS_V3_ACL=y
>   CONFIG_NFS_V4=y
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

