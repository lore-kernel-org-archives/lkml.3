Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaESIGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:06:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18544 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaESIGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:06:54 -0400
Date: Mon, 19 May 2014 11:06:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] staging: dgap: implement error handling in
 dgap_tty_register()
Message-ID: <20140519080634.GM16255@mwanda>
References: <20140519021030.GA1051@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519021030.GA1051@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:10:30AM +0900, Daeseok Youn wrote:
> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
> index d7cfc45..e4cb7aa 100644
> --- a/drivers/staging/dgap/dgap.c
> +++ b/drivers/staging/dgap/dgap.c
> @@ -1212,7 +1212,9 @@ static int dgap_tty_register(struct board_t *brd)
>  {
>  	int rc = 0;

Oh, and you may as well remove this initialization while you are at it.

regards,
dan carpenter

