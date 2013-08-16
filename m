Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3HPHcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:32:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52063 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3HPHct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:32:49 -0400
Date: Fri, 16 Aug 2013 00:32:48 -0700 (PDT)
Message-Id: <20130816.003248.2020720480583171845.davem@davemloft.net>
To: clbchenlibo.chen@huawei.com
Cc: jg1.han@samsung.com, wfp5p@virginia.edu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        lizefan@huawei.com
Subject: Re: [PATCH v3 RESEND 5/7] net: sunhme: use
 platform_{get,set}_drvdata()
From: David Miller <davem@davemloft.net>
In-Reply-To: <520D8F91.2060605@huawei.com>
References: <520D8F91.2060605@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 16 Aug 2013 00:32:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You can't just update one patch and resend it by itself.

You must resubmit the entire series.
