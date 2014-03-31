Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaCaQsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:48:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40629 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaCaQsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:48:38 -0400
Date: Mon, 31 Mar 2014 12:48:34 -0400 (EDT)
Message-Id: <20140331.124834.108407106262962422.davem@davemloft.net>
To: vegard.nossum@gmail.com
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOMGZ=FmOPcL=d3POVM=VEA1Wu-ojUFqJuQ5KxgKB-iPfk1aiA@mail.gmail.com>
References: <1394189764-21754-1-git-send-email-vegard.nossum@oracle.com>
	<CAOMGZ=FmOPcL=d3POVM=VEA1Wu-ojUFqJuQ5KxgKB-iPfk1aiA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Mar 2014 09:48:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 31 Mar 2014 14:56:07 +0200

> Ping, Dave? Just making sure this doesn't fall through the cracks. I
> don't see the patch applied anywhere yet and without this patch we
> still have a valid security concern IMO.

If it's not sent to netdev, it's not in my queue.

