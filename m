Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3LKJ4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:56:51 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:56536 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3LKJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:56:46 -0500
Message-ID: <52A836F0.9070500@gmail.com>
Date: Wed, 11 Dec 2013 11:57:04 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Steven Luo <steven@steven676.net>, devel@driverdev.osuosl.org,
        fabs@goesec.de, tony@atomide.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        pavel@ucw.cz, pali.rohar@gmail.com, nico@ngolde.de
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing
 instead of remap_pfn_range
References: <1386014416-4556-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <20131207234912.GA1245@steven676.net> <52A81830.3000305@gmail.com> <20131211083359.GU28413@mwanda>
In-Reply-To: <20131211083359.GU28413@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.12.2013 10:33, Dan Carpenter wrote:
> On Wed, Dec 11, 2013 at 09:45:52AM +0200, Ivajlo Dimitrov wrote:
>> I can pick your changes and re-send the original patch with them
>> incorporated if there are no objections. Are you fine with that?
>>
> Do it on top of staging-next, don't redo the original.
>
> regards,
> dan carpenter

I don't see the original patch in the staging-next tree [0], how to 
proceed? Isn't it better to resend the original patch with Steven's 
changes included?

[0] 
http://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/log/drivers/staging/tidspbridge?h=staging-next

Regards,
Ivo
