Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3FEKkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:40:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab3FEKkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:40:31 -0400
Message-ID: <51AF158F.9080201@redhat.com>
Date: Wed, 05 Jun 2013 12:40:15 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/10] zram: destroy all devices on error recovery
 path in zram_init()
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com> <1370361968-8764-4-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370361968-8764-4-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 06:06 PM, Jiang Liu wrote:
> On error recovery path of zram_init(), it leaks the zram device object
> causing the failure. So change create_device() to free allocated
> resources on error path.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org

Acked-by: Jerome Marchand <jmarchan@redhat.com>

