Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab3CDTPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:15:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40656 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520Ab3CDTPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:15:38 -0500
Date: Mon, 04 Mar 2013 14:15:36 -0500 (EST)
Message-Id: <20130304.141536.814115651801542145.davem@davemloft.net>
To: silviupopescu1990@gmail.com
Cc: netdev@vger.kernel.org, sjur.brandeland@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] CAIF: fix sparse warning for caif_usb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362380971-23007-1-git-send-email-silviupopescu1990@gmail.com>
References: <1362380971-23007-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 04 Mar 2013 11:15:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Date: Mon,  4 Mar 2013 09:09:31 +0200

> This fixes the following sparse warning:
> net/caif/caif_usb.c:84:16: warning: symbol 'cfusbl_create' was not
> declared. Should it be static?
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Applied.
