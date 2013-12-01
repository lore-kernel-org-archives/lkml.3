Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3LATZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 14:25:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21157 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3LATZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 14:25:09 -0500
Date: Sun, 1 Dec 2013 22:24:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Aldo Iljazi <mail@aldo.io>
Cc: lidza.louina@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Drivers: staging: dgap: checkpatch.pl cleanups
Message-ID: <20131201192447.GK28413@mwanda>
References: <1385912589-32709-1-git-send-email-mail@aldo.io>
 <1385912589-32709-2-git-send-email-mail@aldo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385912589-32709-2-git-send-email-mail@aldo.io>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 01, 2013 at 05:43:09PM +0200, Aldo Iljazi wrote:
>  #define DIGI_DLREQ_GET	(('d'<<8) | 220)
> @@ -57,7 +57,7 @@ struct downldio {
>  #define DIGI_NUKE_RESET_ALL	 (1 << 31)
>  #define DIGI_NUKE_INHIBIT_POLLER (1 << 30)
>  #define DIGI_NUKE_BRD_NUMB        0x0f
> -	
> +
>  
>  
>  #define	DLREQ_BIOS	0

We shouldn't have two blank lines in a row.

regards,
dan carpenter

