Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaFKHMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:12:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42942 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFKHMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:12:18 -0400
Date: Wed, 11 Jun 2014 00:12:16 -0700 (PDT)
Message-Id: <20140611.001216.1631681094950454220.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] dns_resolver: assure that dns_query() result is
 null-terminated
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402178245-8076-1-git-send-email-manuel.schoelling@gmx.de>
References: <1402167681-24676-1-git-send-email-manuel.schoelling@gmx.de>
	<1402178245-8076-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Jun 2014 00:12:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Sat,  7 Jun 2014 23:57:25 +0200

> dns_query() credulously assumes that keys are null-terminated and
> returns a copy of a memory block that is off by one.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Applied, thanks.
