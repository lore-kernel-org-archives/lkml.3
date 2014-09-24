Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaIXHkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:40:51 -0400
Received: from senator.holtmann.net ([87.106.208.187]:45643 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaIXHku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:40:50 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH net-next] bluetooth: Convert bt_<level> logging functions to return void
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1411409861.2952.57.camel@joe-AO725>
Date: Wed, 24 Sep 2014 09:40:51 +0200
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <54204FE6-FE0E-4826-93DC-4A6BF6A4F03D@holtmann.org>
References: <1411409861.2952.57.camel@joe-AO725>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> No caller or macro uses the return value so make all
> the functions return void.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> This change is associated to a desire to eventually
> change printk to return void.
> 
> include/net/bluetooth/bluetooth.h |  4 ++--
> net/bluetooth/lib.c               | 14 ++++----------
> 2 files changed, 6 insertions(+), 12 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

