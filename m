Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3J1EjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 00:39:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56348 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3J1EjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 00:39:10 -0400
Date: Mon, 28 Oct 2013 00:39:09 -0400 (EDT)
Message-Id: <20131028.003909.1948178447168051444.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH 2/3] net, datagram: fix the uncorrect comment in
 zerocopy_sg_from_iovec()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382687360-27794-2-git-send-email-zwu.kernel@gmail.com>
References: <1382687360-27794-1-git-send-email-zwu.kernel@gmail.com>
	<1382687360-27794-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 27 Oct 2013 21:39:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"uncorrect" is not a word, you mean to say "incorrect".

Same goes for patch #3.
