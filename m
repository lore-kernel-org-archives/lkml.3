Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3IVS7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 14:59:01 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:55088 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3IVS7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:59:00 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 2/5] Bluetooth: Fix assignment of 0/1 to bool variables
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1379875453-20083-2-git-send-email-peter.senna@gmail.com>
Date: Sun, 22 Sep 2013 13:58:56 -0500
Cc: gustavo@padovan.org, johan.hedberg@gmail.com, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <B0200EA6-8CDA-41BE-9DD1-0A0E9CFDB2B5@holtmann.org>
References: <1379875453-20083-1-git-send-email-peter.senna@gmail.com> <1379875453-20083-2-git-send-email-peter.senna@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

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
> net/bluetooth/l2cap_core.c |   16 ++++++++--------
> 1 file changed, 8 insertions(+), 8 deletions(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

