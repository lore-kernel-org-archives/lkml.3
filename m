Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbaDXMZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:25:49 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34804 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaDXMZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:25:46 -0400
Date: Thu, 24 Apr 2014 08:25:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kefeng Wang <kefeng.wang@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: linux-next: build failure after merge of the libata tree
Message-ID: <20140424122534.GK4781@htj.dyndns.org>
References: <20140424111754.45e9672e06c362945d111b6e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424111754.45e9672e06c362945d111b6e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 24, 2014 at 11:17:54AM +1000, Stephen Rothwell wrote:
> After merging the libata tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/ata/libahci_platform.c: In function 'ahci_platform_init_host':
> drivers/ata/libahci_platform.c:317:20: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   pi.private_data = (void *)host_flags
>                     ^
> drivers/ata/libahci_platform.c:318:2: error: expected ';' before 'hpriv'
>   hpriv->flags |= host_flags;
>   ^
> 
> Please test build this stuff ...

My apologies.

> Caused by commit ac795a7ec2d2 ("libahci_platform: add host_flags parameter
> in ahci_platform_init_host()").
> 
> I have used the libata tree from next-20140423 for today.

Reverted.

Thanks.

-- 
tejun
