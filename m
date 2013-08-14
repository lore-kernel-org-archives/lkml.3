Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab3HNS43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:56:29 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:39403 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057Ab3HNS41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:56:27 -0400
Message-ID: <520BD2E3.9080606@cogentembedded.com>
Date: Wed, 14 Aug 2013 22:56:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        leoli@freescale.com, linuxppc-dev@lists.ozlabs.org,
        pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
        Greg KH <gregkh@linuxfoundation.org>, jg1.han@samsung.com
Subject: Re: [PATCH RESEND 0/8] use platform_{get,set}_drvdata()
References: <5208E20A.4010306@huawei.com> <520AFB3F.2090006@huawei.com>
In-Reply-To: <520AFB3F.2090006@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 07:36 AM, Libo Chen wrote:

> We can use the wrapper functions platform_{get,set}_drvdata() instead of
> dev_{get,set}_drvdata() with &pdev->dev, it is convenient for user.
>
> Also, unnecessary dev_set_drvdata() is removed, because the driver core
> clears the driver data to NULL after device_release or on probe failure.

    Saying "also" in the changelog is usually a good sign that the patch 
should be split.

WBR, Sergei

