Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaEZKgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:36:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40302 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaEZKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:36:37 -0400
Date: Mon, 26 May 2014 13:36:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Heesub Shin <heesub.shin@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Sunghwan Yun <sunghwan.yun@samsung.com>,
        Daeseok Youn <daeseok.youn@gmail.com>, linux-kernel@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: Re: [PATCH 1/9] staging: ion: tidy up a bit
Message-ID: <20140526103612.GE15585@mwanda>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 07:04:53PM +0900, Heesub Shin wrote:
> @@ -124,7 +122,6 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
>  
>  		info->page = page;
>  		info->order = orders[i];
> -		INIT_LIST_HEAD(&info->list);
>  		return info;
>  	}
>  	kfree(info);

Wait.  How does this code work without that INIT_LIST_HEAD()?  What am
I missing here...

regards,
dan carpenter


