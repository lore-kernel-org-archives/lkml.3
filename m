Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3JWJ16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:27:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:62407 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3JWJ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:27:57 -0400
Message-ID: <52679692.2000900@windriver.com>
Date: Wed, 23 Oct 2013 17:27:46 +0800
From: =?UTF-8?B?IuKAnHRpZWp1bi5jaGVu4oCdIg==?= 
	<tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [v5][PATCH 4/6] powerpc/book3e: support kgdb for kernel space
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>	 <1371724110-8250-5-git-send-email-tiejun.chen@windriver.com> <1382137119.7979.916.camel@snotra.buserror.net>
In-Reply-To: <1382137119.7979.916.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 06:58 AM, Scott Wood wrote:
> On Thu, 2013-06-20 at 18:28 +0800, Tiejun Chen wrote:
>> Currently we need to skip this for supporting KGDB.
>
> Does it need to depend on CONFIG_KGDB?  Either you've fixed the "can't
> quite save properly" part, or you haven't.

I'm not 100% sure if my change is fine to other scenarios so I have to use this 
guarantee other stuff are still safe. But if you think we can remove this 
dependent, I'm happy to do :)

Thanks,

Tiejun
