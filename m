Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab3GQS5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:57:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab3GQS5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:57:18 -0400
Date: Wed, 17 Jul 2013 11:57:15 -0700 (PDT)
Message-Id: <20130717.115715.965921785189776151.davem@davemloft.net>
To: kys@microsoft.com
Cc: haiyangz@microsoft.com, netdev@vger.kernel.org, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix the NETIF_F_SG flag setting in netvsc
From: David Miller <davem@davemloft.net>
In-Reply-To: <8906250c5dfc4f7ab0d84019bf7b9a44@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1374040880-20468-1-git-send-email-haiyangz@microsoft.com>
	<8906250c5dfc4f7ab0d84019bf7b9a44@SN2PR03MB061.namprd03.prod.outlook.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 17 Jul 2013 11:57:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KY Srinivasan <kys@microsoft.com>
Date: Wed, 17 Jul 2013 11:40:41 +0000

> 
> 
>> -----Original Message-----
>> From: Haiyang Zhang [mailto:haiyangz@microsoft.com]
>> Sent: Wednesday, July 17, 2013 2:01 AM
>> To: davem@davemloft.net; netdev@vger.kernel.org
>> Cc: Haiyang Zhang; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com; linux-
>> kernel@vger.kernel.org; devel@linuxdriverproject.org
>> Subject: [PATCH net] hyperv: Fix the NETIF_F_SG flag setting in netvsc
>> 
>> SG mode is not currently supported by netvsc, so remove this flag for now.
>> Otherwise, it will be unconditionally enabled by commit ec5f0615642
>>     "Kill link between CSUM and SG features"
>> Previously, the SG feature is disabled because CSUM is not set here.
>> 
>> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> We would need to apply this patch to 3.9 and 3.10 as well that are currently broken.

I have already queued this patch up for -stable submission.
