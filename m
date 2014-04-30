Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945954AbaD3Rgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:36:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42297 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422723AbaD3Rgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:36:47 -0400
Date: Wed, 30 Apr 2014 13:36:45 -0400 (EDT)
Message-Id: <20140430.133645.1431735801141049226.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on
 the send path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398878071-21307-1-git-send-email-kys@microsoft.com>
References: <1398878071-21307-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Apr 2014 10:36:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Wed, 30 Apr 2014 10:14:31 -0700

> We send packets using a copy-free mechanism (this is the Guest to Host transport
> via VMBUS). While this is obviously optimal for large packets,
> it may not be optimal for small packets. Hyper-V host supports
> a second mechanism for sending packets that is "copy based". We implement that
> mechanism in this patch.
> 
> In this version of the patch I have addressed a comment from David Miller.
> 
> With this patch (and all of the other offload and VRSS patches), we are now able
> to almost saturate a 10G interface between Linux VMs on Hyper-V
> on different hosts - close to  9 Gbps as measured via iperf.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied.
