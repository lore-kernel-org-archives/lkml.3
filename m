Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab3FGJf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:35:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab3FGJf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:35:28 -0400
Message-ID: <51B1A94F.3060005@redhat.com>
Date: Fri, 07 Jun 2013 11:35:11 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/10] zram: avoid double free in function zram_bvec_write()
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com> <1370361968-8764-5-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370361968-8764-5-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 06:06 PM, Jiang Liu wrote:
> When doing a patial write and the whole page is filled with zero,
> zram_bvec_write() will free uncmem twice.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org

I thought I acked this one already. I guess I didn't.

Acked-by: Jerome Marchand <jmarchan@redhat.com>


