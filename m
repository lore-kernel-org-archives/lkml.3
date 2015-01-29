Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbbA2ISs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:18:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55945 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbbA2ISq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:18:46 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [RESEND] ssb: Fix Sparse error in main
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422424187-19059-1-git-send-email-pramod.gurav@smartplayin.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: John Linville <linville@tuxdriver.com>, Michael Buesch <m@bues.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Message-Id: <20150129081845.D4BA813FE12@smtp.codeaurora.org>
Date: Thu, 29 Jan 2015 08:18:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This change fixes below sparse error:
> drivers/ssb/main.c:94:16: warning: symbol 'ssb_sdio_func_to_bus'
> was not declared. Should it be static?
> 
> Acked-by: Michael Buesch <m@bues.ch>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
