Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaHMIvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:51:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37358 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaHMIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:51:06 -0400
Date: Wed, 13 Aug 2014 11:50:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roger <rogerable@realtek.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn
Subject: Re: [PATCH] mmc: rtsx: fix incorrect last byte in R2 response
Message-ID: <20140813085024.GQ11899@mwanda>
References: <1407745936-18513-1-git-send-email-rogerable@realtek.com>
 <20140811130254.GP4856@mwanda>
 <53E9BFF0.5030506@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E9BFF0.5030506@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 03:19:12PM +0800, Roger wrote:
> I can remove the unused rsp_len in this function. But I'm afraid the
> loop is still required. The destination cmd->resp is cpu-endian, but
> the raw response from SD card in the buffer (pointed by ptr) is
> big-endian.

Oh, yes.  Of course.  Sorry for the noise.

regards,
dan carpenter

