Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaL3XeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 18:34:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36606 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaL3XeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 18:34:15 -0500
Date: Tue, 30 Dec 2014 18:32:01 -0500 (EST)
Message-Id: <20141230.183201.53211717284248412.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, amirv@mellanox.com,
        ariel.elior@qlogic.com, carolyn.wyborny@intel.com,
        Frank.Li@freescale.com, jeffrey.t.kirsher@intel.com,
        john.stultz@linaro.org, matthew.vick@intel.com, mlichvar@redhat.com,
        mugunthanvnm@ti.com, ogerlitz@mellanox.com, tglx@linutronix.de,
        thomas.lendacky@amd.com
Subject: Re: [PATCH net-next 00/11] Time Counter fixes and improvements
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1418504883.git.richardcochran@gmail.com>
References: <cover.1418504883.git.richardcochran@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Dec 2014 15:34:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Sun, 21 Dec 2014 19:46:55 +0100

> Several PTP Hardware Clock (PHC) drivers implement the clock in
> software using the timecounter/cyclecounter code. This series adds one
> simple improvement and one more subtle fix to the shared timecounter
> facility. Credit for this series goes to Janusz U¿ycki, who pointed
> the issues out to me off list.

Series applied, thanks Richard.
