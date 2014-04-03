Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaDCQZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:25:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59304 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaDCQZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:25:00 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 2/9] crypto: qce: Add register defines
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com>
Date: Thu, 3 Apr 2014 11:24:55 -0500
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <69C277DD-FAB2-4102-BA97-8C1985E099CB@codeaurora.org>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 3, 2014, at 11:17 AM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:

> Here are all register addresses and bit/masks used by the driver.
> 
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
> drivers/crypto/qce/regs-v5.h | 327 +++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 327 insertions(+)
> create mode 100644 drivers/crypto/qce/regs-v5.h

This should be part of the first patch in the series, you shouldn’t have any patch that doesn’t build.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

