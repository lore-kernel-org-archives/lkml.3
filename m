Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab3EKX3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 19:29:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60325 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3EKX3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 19:29:39 -0400
Date: Sat, 11 May 2013 16:29:38 -0700 (PDT)
Message-Id: <20130511.162938.1866852237817212733.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, dmitry.tarnyagin@lockless.no,
        netdev@vger.kernel.org
Subject: Re: [PATCH 10/12] caif: CAIF_VIRTIO should depend on HAS_DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <1368133494-22198-10-git-send-email-geert@linux-m68k.org>
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
	<1368133494-22198-10-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu,  9 May 2013 23:04:52 +0200

> If NO_DMA=y:
 ...
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
