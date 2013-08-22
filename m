Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3HVFyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:54:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47076 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3HVFyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <1377068561-15744-1-git-send-email-libo.chen@huawei.com>
References: <1377068561-15744-1-git-send-email-libo.chen@huawei.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 22 Aug 2013 11:23:44 +0530
Message-ID: <CA+V-a8v7_ZdX4FSeEdgq1tFxjDVNW9+LGbQm8YrVhXchXkWxdw@mail.gmail.com>
Subject: Re: [PATCH 7/8] net: davinci_mdio: remove unnecessary dev_set_drvdata()
To: Libo Chen <libo.chen@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Mugunthan V N <mugunthanvnm@ti.com>, bigeasy@linutronix.de,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Libo,

Thanks for the patch.

On Wed, Aug 21, 2013 at 12:32 PM, Libo Chen <libo.chen@huawei.com> wrote:
> Unnecessary dev_set_drvdata() is removed, because the driver core
> clears the driver data to NULL after device_release or on probe failure.
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
