Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaIDPbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:31:04 -0400
Received: from mxout5.netvision.net.il ([194.90.6.65]:46866 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaIDPbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:31:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <540883FC.4040706@gmail.com>
Date: Thu, 04 Sep 2014 18:23:40 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: xillybus: Move out of staging
References: <1409471821-11809-1-git-send-email-eli.billauer@gmail.com>
 <20140901121318.GG5122@mwanda>
In-reply-to: <20140901121318.GG5122@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan.

I've just submitted the patches for the staging git tree (yourself 
Cc'ed). I didn't have any objections on your comments, so there isn't 
much to add -- except for thank you. :)

Regards,
    Eli

On 01/09/14 15:13, Dan Carpenter wrote:
> Pretty nice.  This is very special purpose hardware and the UAPI for
> this is fine.  The documentation seems good.  I had some minor style
> comments but nothing major stands out.
>
> These days I quite like the --strict option for checkpatch.pl.
>
> for i in $(find drivers/staging/xillybus/ -name \*\.c)
> 	do ./scripts/checkpatch.pl --strict -f $i
> done
>
>    

