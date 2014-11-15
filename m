Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935386AbaKOAcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 19:32:05 -0500
Received: from senator.holtmann.net ([87.106.208.187]:43660 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934338AbaKOAcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 19:32:03 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [PATCH 1/1 net-next] Bluetooth: hidp: replace kzalloc/copy_from_user by memdup_user
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1415990105-28609-1-git-send-email-fabf@skynet.be>
Date: Sat, 15 Nov 2014 09:31:51 +0900
Cc: linux-kernel@vger.kernel.org, "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7620CAF7-8060-4C5A-8055-53595B7B78F0@holtmann.org>
References: <1415990105-28609-1-git-send-email-fabf@skynet.be>
To: Fabian Frederick <fabf@skynet.be>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

> use memdup_user for rd_data import.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> net/bluetooth/hidp/core.c | 10 +++-------
> 1 file changed, 3 insertions(+), 7 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

