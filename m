Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3HPRP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:15:27 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:48999 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3HPRPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <520CD13E.7090802@huawei.com>
References: <520CD13E.7090802@huawei.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 16 Aug 2013 22:45:03 +0530
Message-ID: <CA+V-a8vgOWzu9d-kfw4Qp5N7AU3p=Jb8tGmak4aRNq49WKpJdA@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] net: davinci_mdio: use platform_{get,set}_drvdata()
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: David Miller <davem@davemloft.net>, Mugunthan V N <mugunthanvnm@ti.com>,
        bigeasy@linutronix.de, b-liu@ti.com, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 6:31 PM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
