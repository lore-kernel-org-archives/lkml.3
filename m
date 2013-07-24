Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab3GXSJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:09:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50049 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3GXSJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:09:53 -0400
Message-ID: <51F0186B.1050407@gmail.com>
Date: Thu, 25 Jul 2013 02:09:47 +0800
From: Peng Tao <bergwolf@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH-RESEND 2/3] staging/lustre: fix build on non-x86
References: <1374688821-9874-1-git-send-email-bergwolf@gmail.com> <1374688821-9874-3-git-send-email-bergwolf@gmail.com> <20130724180516.GA4958@kroah.com>
In-Reply-To: <20130724180516.GA4958@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 02:05 AM, Greg Kroah-Hartman wrote:
> On Thu, Jul 25, 2013 at 02:00:20AM +0800, Peng Tao wrote:
>> On non-x86 we will build with Lustre's errno translate code but
>> it has a few issues.
>>
>> Cc: Andreas Dilger <andreas.dilger@intel.com>
>> Signed-off-by: Peng Tao <tao.peng@emc.com>
> You forgot your "From: Peng Tao <tao.peng@emc.com>" line in this, and
> the third, patch to get the authorship correct.
I'll fix and resend. Sorry for the noise...

Thanks,
Tao
> thanks,
>
> greg k-h

