Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbaJ3QYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:24:34 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35022 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbaJ3QYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:24:32 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [patch] Bluetooth: 6lowpan: use after free in disconnect_devices()
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141029161057.GF5290@mwanda>
Date: Thu, 30 Oct 2014 09:24:23 -0700
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3DFF075B-22A1-4E52-8675-00207AE385C4@holtmann.org>
References: <20141029161057.GF5290@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

> This was accidentally changed from list_for_each_entry_safe() to
> list_for_each_entry() so now it has a use after free bug.  I've changed
> it back.
> 
> Fixes: 90305829635d ('Bluetooth: 6lowpan: Converting rwlocks to use RCU')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

patch has been applied to bluetooth-next tree.

Regards

Marcel

