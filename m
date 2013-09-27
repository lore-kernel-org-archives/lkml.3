Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3I0M2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:28:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30726 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3I0M2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:28:12 -0400
Date: Fri, 27 Sep 2013 15:27:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Berglund <martin@rogsta.net>
Cc: teddy.wang@siliconmotion.com.cn, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, wfp5p@virginia.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: sm7xxfb: fixed line break coding style issues
Message-ID: <20130927122728.GE6192@mwanda>
References: <1380283687-21524-1-git-send-email-martin@rogsta.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380283687-21524-1-git-send-email-martin@rogsta.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 02:08:07PM +0200, Martin Berglund wrote:
> @@ -508,9 +506,8 @@ static void sm7xx_set_timing(struct smtcfb_info *sfb)
>  
>  			/* init SEQ register SR30 - SR75 */
>  			for (i = 0; i < SIZE_SR30_SR75; i++)
> -				if (((i + 0x30) != 0x62) \
> -					&& ((i + 0x30) != 0x6a) \
> -					&& ((i + 0x30) != 0x6b))
> +				if (((i + 0x30) != 0x62) && ((i + 0x30) != 0x6a)
> +							&& ((i + 0x30) != 0x6b))

The prefered way would be to align this like this:

				if ((i + 0x30) != 0x62 &&
				    (i + 0x30) != 0x6a &&
				    (i + 0x30) != 0x6b)

regards,
dan carpenter

