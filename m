Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaGJIoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:44:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37270 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaGJIn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:43:58 -0400
Date: Thu, 10 Jul 2014 01:43:55 -0700 (PDT)
Message-Id: <20140710.014355.387392730830362973.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dh.herrmann@gmail.com, kay@vrfy.org
Subject: Re: [PATCH v7 00/33] Provide netdev naming-policy via sysfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404980258-30853-1-git-send-email-teg@jklm.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 10 Jul 2014 01:43:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is not reasonable to expect people to review such a large number of
patches at one time.

Split your series up into logical, and more reasonably sized chunks.

I'd say 14 or 15 at a time is the limit.

I'm not even looking at this series until you submit it more reasonably.

Thank you.
