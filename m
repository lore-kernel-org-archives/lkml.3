Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaGaAZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:25:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37748 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaGaAZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:25:24 -0400
Date: Wed, 30 Jul 2014 17:25:23 -0700 (PDT)
Message-Id: <20140730.172523.1080858143706717134.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: net-next: hyperv
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406769616-29871-1-git-send-email-kys@microsoft.com>
References: <1406769616-29871-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Jul 2014 17:25:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Wed, 30 Jul 2014 18:20:16 -0700

> For forwarding scenarios, it will be useful to allocate larger
> sendbuf. Make the necessary adjustments to permit this.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Please submit this with a proper Subject line, something like
"[PATCH 1/1] hyperv: ${DESCRIPTION}" would be fine.

As is, nobody scanning the commit headers in the tree history can
see what might be unique about this change to the hyperv driver
vs. all others, because you haven't written a proper description.
