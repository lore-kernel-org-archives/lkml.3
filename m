Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaHFUwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:52:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43614 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaHFUwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:52:34 -0400
Date: Wed, 06 Aug 2014 13:52:32 -0700 (PDT)
Message-Id: <20140806.135232.339777611093154433.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: net-next: hyperv: Adjust the size of
 sendbuf region to support ws2008r2
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407348660-6844-1-git-send-email-kys@microsoft.com>
References: <1407348660-6844-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Aug 2014 13:52:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Wed,  6 Aug 2014 11:11:00 -0700

> WS2008R2 is a supported platform and it turns out that the maximum sendbuf
> size that ws2008R2 can support is only 15MB. Make the necessary
> adjustment.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
