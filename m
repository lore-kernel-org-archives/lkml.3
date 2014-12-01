Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaLAKJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:09:11 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:42712 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbaLAKJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:09:09 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <547C3E42.1050106@mev.co.uk>
Date: Mon, 01 Dec 2014 10:09:06 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: change some printk calls to pr_err
References: <1417410356-25504-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1417410356-25504-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/14 05:05, Chase Southwood wrote:
> There are a handful of calls to printk in ni_stc.h without specified log
> levels, as well as one in ni_mio_common.c.  This patch converts these
> calls to pr_err() instead, so that they are now explicitly log level
> ERR.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> ---
> I tacked the change to ni_mio_common.c on to this patch since it's the same
> exact change and it's just one line, so I think a single patch is justified
> here.
>   drivers/staging/comedi/drivers/ni_mio_common.c |  2 +-
>   drivers/staging/comedi/drivers/ni_stc.h        | 14 +++++++-------
>   2 files changed, 8 insertions(+), 8 deletions(-)

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
