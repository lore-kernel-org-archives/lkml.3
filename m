Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaD1MQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:16:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24394 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaD1MQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:16:55 -0400
Date: Mon, 28 Apr 2014 15:16:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky <micky_ching@realsil.com.cn>
Cc: chris@printf.net, sameo@linux.intel.com, gregkh@linuxfoundation.org,
        ulf.hansson@linaro.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH v2 1/2] mmc: rtsx: add R1-no-CRC mmc command type handle
Message-ID: <20140428121627.GL4963@mwanda>
References: <cover.1395824147.git.micky_ching@realsil.com.cn>
 <afbc1328fb8a89fda3da23f1e9c755311450e1f6.1395824147.git.micky_ching@realsil.com.cn>
 <535E3BEC.9040100@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E3BEC.9040100@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 07:30:52PM +0800, micky wrote:
> Hi Chris and Ulf,
> 
> This patch should be applied to 3.15(rc), 3.14, 3.13.
> without this patch the MMC card can not identified.
> 

Top posting is annoying.

If Chris and Ulf don't mind then you could actually deal with this by
yourself.  Read Documentation/stable_kernel_rules.txt

regards,
dan carpenter

