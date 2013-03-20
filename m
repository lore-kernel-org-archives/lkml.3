Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3CTRYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:24:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3CTRYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:24:37 -0400
Date: Wed, 20 Mar 2013 13:24:34 -0400 (EDT)
Message-Id: <20130320.132434.1915240905937319723.davem@davemloft.net>
To: jderehag@hotmail.com
Cc: zbr@ioremap.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] connector: Added coredumping event to the
 process connector
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363762205-26206-1-git-send-email-jderehag@hotmail.com>
References: <1363762205-26206-1-git-send-email-jderehag@hotmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Mar 2013 10:24:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Derehag <jderehag@hotmail.com>
Date: Wed, 20 Mar 2013 07:50:05 +0100

> Process connector can now also detect coredumping events.
> Main aim of patch is get notified at start of coredumping, instead of having to wait for it to finish and then being notified through EXIT event.
> Could be used for instance by process-managers that want to get notified as soon as possible about process failures, and not necessarily beeing notified after coredump, which could be in the order of minutes depending on size of coredump, piping and so on.
> 
> Signed-off-by: Jesper Derehag <jderehag@hotmail.com>

Applied, thanks.
