Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3GBT4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:56:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53391 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab3GBT4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:56:07 -0400
Date: Tue, 02 Jul 2013 12:56:06 -0700 (PDT)
Message-Id: <20130702.125606.2222663509004529601.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, willemb@google.com,
        erdnetdev@gmail.com, andi@firstfloor.org, hpa@zytor.com,
        devel-lists@codyps.com, eliezer@tamir.org.il
Subject: Re: [PATCH v2 net-next] net: convert lls to use time_in_range()
From: David Miller <davem@davemloft.net>
In-Reply-To: <51D2A246.3000705@linux.intel.com>
References: <51D2919F.7050007@linux.intel.com>
	<51D29329.4060004@linux.intel.com>
	<51D2A246.3000705@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Tue, 02 Jul 2013 12:49:58 +0300

> @@ -403,7 +403,8 @@ int do_select(int n, fd_set_bits *fds, struct
> timespec *end_time)

Your email client has corrupted this patch, please repost with this
issue corrected.

Thanks.
