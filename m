Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3IVWVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:21:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39558 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3IVWVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:21:32 -0400
Date: Sun, 22 Sep 2013 17:21:29 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/5] Bluetooth: Fix assignment of 0/1 to bool variables
Message-ID: <20130922222129.GE18215@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Peter Senna Tschudin <peter.senna@gmail.com>, marcel@holtmann.org,
	johan.hedberg@gmail.com, davem@davemloft.net,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
 <1379875453-20083-2-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379875453-20083-2-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

2013-09-22 Peter Senna Tschudin <peter.senna@gmail.com>:

> Convert 0 to false and 1 to true when assigning values to bool
> variables. Inspired by commit 3db1cd5c05f35fb43eb134df6f321de4e63141f2.
> 
> The simplified semantic patch that find this problem is as
> follows (http://coccinelle.lip6.fr/):
> 
> @@
> bool b;
> @@
> (
> -b = 0
> +b = false
> |
> -b = 1
> +b = true
> )
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
>  net/bluetooth/l2cap_core.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Patch has been applied to bluetooth-next. Thanks.

	Gustavo
