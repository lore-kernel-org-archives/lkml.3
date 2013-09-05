Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3IEQqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:46:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33989 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3IEQqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:46:38 -0400
Date: Thu, 05 Sep 2013 12:46:36 -0400 (EDT)
Message-Id: <20130905.124636.366480066838393015.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH V2 net-next 1/2] tuntap: purge socket error queue on
 detach
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378374840-39130-1-git-send-email-jasowang@redhat.com>
References: <1378374840-39130-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 09:46:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu,  5 Sep 2013 17:53:59 +0800

> Commit eda297729171fe16bf34fe5b0419dfb69060f623
> (tun: Support software transmit time stamping) will queue skbs into error queue
> when tx stamping is enabled. But it forgets to purge the error queue during
> detach. This patch fixes this.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.
