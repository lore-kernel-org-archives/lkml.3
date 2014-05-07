Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaEGTlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:41:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51157 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaEGTlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:41:10 -0400
Date: Wed, 07 May 2014 15:41:08 -0400 (EDT)
Message-Id: <20140507.154108.567253192690937393.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, amirv@mellanox.com, eli@mellanox.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] mellanox: Logging message cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <e029b6ed75d46cfbada06622df91d4d331eeabde.1399259459.git.joe@perches.com>
References: <e029b6ed75d46cfbada06622df91d4d331eeabde.1399259459.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 07 May 2014 12:41:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Joe, please get rid of the initial empty line you're adding to fw.c and
resubmit with Amir's ACK.

Thanks.
