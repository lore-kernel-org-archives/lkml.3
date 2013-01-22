Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3AVK3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:29:37 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:18380
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab3AVK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:29:34 -0500
X-IronPort-AV: E=Sophos;i="4.84,513,1355094000"; 
   d="scan'208";a="169299124"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] use ERR_CAST
Date: Tue, 22 Jan 2013 12:29:25 +0100
Message-Id: <1358854166-3952-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERR_CAST is more concise than PTR_ERR followed by ERR_PTR.  Using it
also occasionally removes the need for an err variable.

