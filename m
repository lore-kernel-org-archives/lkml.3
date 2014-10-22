Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbaJVV7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:59:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33701 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbaJVV7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:59:23 -0400
Date: Wed, 22 Oct 2014 17:59:20 -0400 (EDT)
Message-Id: <20141022.175920.1800807867580631439.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix the total_data_buflen in send path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414010838-20656-1-git-send-email-haiyangz@microsoft.com>
References: <1414010838-20656-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Oct 2014 14:59:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 22 Oct 2014 13:47:18 -0700

> total_data_buflen is used by netvsc_send() to decide if a packet can be put
> into send buffer. It should also include the size of RNDIS message before the
> Ethernet frame. Otherwise, a messge with total size bigger than send_section_size
> may be copied into the send buffer, and cause data corruption.
> 
> [Request to include this patch to the Stable branches]
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied and queued up for -stable, thanks.
