Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3EWGnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:43:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51423 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3EWGnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:43:13 -0400
Date: Wed, 22 May 2013 23:43:12 -0700 (PDT)
Message-Id: <20130522.234312.1032864322975853259.davem@davemloft.net>
To: emilio@elopez.com.ar
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: ethernet: korina: drop unused variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369267057-9371-2-git-send-email-emilio@elopez.com.ar>
References: <20130522.122624.266893118412034519.davem@davemloft.net>
	<1369267057-9371-1-git-send-email-emilio@elopez.com.ar>
	<1369267057-9371-2-git-send-email-emilio@elopez.com.ar>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>
Date: Wed, 22 May 2013 20:57:36 -0300

> Commit e998fd4 ("net: ethernet: korina: initialize variables directly")
> dropped the only loop that was using i but did not remove the actual
> variable, therefore causing a warning when building. This patch drops
> the now redundant line.
> 
> Signed-off-by: Emilio López <emilio@elopez.com.ar>

Applied.
