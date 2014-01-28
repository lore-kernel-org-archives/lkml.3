Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaA1Bwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:52:43 -0500
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:49568 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751121AbaA1Bwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:52:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:4321:5007:7652:10004:10400:10848:11026:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: range53_8bc25d8d22318
X-Filterd-Recvd-Size: 1635
Message-ID: <1390873957.20150.78.camel@joe-AO722>
Subject: Re: [PATCH 1/1] Fixed some coding style problems
From: Joe Perches <joe@perches.com>
To: Brandon Stewart <stewartb2@gmail.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2014 17:52:37 -0800
In-Reply-To: <1390873397-4470-1-git-send-email-stewartb2@gmail.com>
References: <1390873397-4470-1-git-send-email-stewartb2@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 19:43 -0600, Brandon Stewart wrote:
[]
> diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
[]
> @@ -624,8 +623,7 @@ do_adb_query(struct adb_request *req)
>  {
>  	int	ret = -EINVAL;
>  
> -	switch(req->data[1])
> -	{
> +	switch(req->data[1]) {

	switch (req->data[1]) {

> @@ -794,8 +792,8 @@ static ssize_t adb_write(struct file *file, const char __user *buf,
>  	}
>  	/* Special case for ADB_BUSRESET request, all others are sent to
>  	   the controller */
> -	else if ((req->data[0] == ADB_PACKET)&&(count > 1)
> -		&&(req->data[1] == ADB_BUSRESET)) {
> +	else if ((req->data[0] == ADB_PACKET) && (count > 1)
> +		&& (req->data[1] == ADB_BUSRESET)) {

	else if (req->data[0] == ADB_PACKET &&
		 req->data[1] == ADB_BUSRESET &&
		 count > 1) {


