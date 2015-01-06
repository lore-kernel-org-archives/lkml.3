Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbbAFS1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:27:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52185 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbAFS1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:27:22 -0500
Date: Tue, 06 Jan 2015 13:27:19 -0500 (EST)
Message-Id: <20150106.132719.85215859897492631.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux@roeck-us.net
Subject: Re: [PATCH net-next] arm_arch_timer: include clocksource.h directly
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420550773-6752-1-git-send-email-richardcochran@gmail.com>
References: <1420550773-6752-1-git-send-email-richardcochran@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 10:27:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Tue,  6 Jan 2015 14:26:13 +0100

> This driver makes use of the clocksource code. Previously it had only
> included the proper header indirectly, but that chain was inadvertently
> broken by 74d23cc "time: move the timecounter/cyclecounter code into its
> own file."
> 
> This patch fixes the issue by including clocksource.h directly.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Applied.
