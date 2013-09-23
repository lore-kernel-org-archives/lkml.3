Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3IWI2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:28:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46168 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3IWI2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:28:22 -0400
X-Spam-Score: -100.6
Message-ID: <523FFB5F.4030501@asianux.com>
Date: Mon, 23 Sep 2013 16:27:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: include: asm: uaccess.h: include "asm-generic/uaccess-unaligned.h"
References: <523E6274.3030602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DF30@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307514DF30@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 04:07 PM, Vineet Gupta wrote:
> On 09/22/2013 08:53 AM, Chen Gang wrote:
>> Need include the default implementation, just like another platforms
>> (e.g. parisc, tile ...), or can not pass compiling.
>>
>> The related error (with allmodconfig for arc):
>>
>>     CC [M]  fs/btrfs/ioctl.o
>>   fs/btrfs/ioctl.c: In function �btrfs_ioctl_file_extent_same�:
>>   fs/btrfs/ioctl.c:2802: error: implicit declaration of function �__put_user_unaligned�
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Acked-by: Vineet Gupta <vgupta@synopsys.com>
> 

Thank you too.

> Thx,
> -Vineet
> 
> 


-- 
Chen Gang
