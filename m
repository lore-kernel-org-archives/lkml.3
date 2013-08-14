Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab3HNSyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:54:40 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34512 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab3HNSyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:54:38 -0400
Message-ID: <520BD275.5060004@cogentembedded.com>
Date: Wed, 14 Aug 2013 22:54:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 1/8] net: fsl_pq_mdio: use platform_{get,set}_drvdata()
References: <5208E215.6030007@huawei.com> <520AFBEE.7030903@huawei.com>
In-Reply-To: <520AFBEE.7030903@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/14/2013 07:39 AM, Libo Chen wrote:

> We can use the wrapper functions platform_{get,set}_drvdata() instead of
> dev_{get,set}_drvdata() with &pdev->dev, it is convenient for user.

> Also, unnecessary dev_set_drvdata() is removed, because the driver core
> clears the driver data to NULL after device_release or on probe failure.

    You misunderstood. That's a material for 2 separate patch sets (or maybe 
single patches, since multiple files can be collapsed in a single patch).

> Signed-off-by: Libo Chen <libo.chen@huawei.com>

WBR, Sergei

