Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655Ab3E1Pxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:53:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57463 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934550Ab3E1Pxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:53:49 -0400
Date: Tue, 28 May 2013 17:53:43 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
Message-ID: <20130528175343.77c6353d@skate>
In-Reply-To: <20130528154047.GT31290@titan.lakedaemon.net>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130528154047.GT31290@titan.lakedaemon.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jason Cooper,

On Tue, 28 May 2013 11:40:47 -0400, Jason Cooper wrote:

> In order to avoid losing changes between this series and mvebu/pcie,
> I've rebased this series on top of mvebu/pcie and incorporated the
> correct conflict resolution into this series.  See below...

Thanks!

> I'm posting the revised version as replies to patches 1, 5 and 6. Please
> let me know if I messed it up.  I'd like to send the PR for these
> shortly.

I had a quick look, and it looks good to me. Let me know to which
branch you've pushed this, and the merge order to follow to "rebuild"
something that works, and I'll try to find some time to test it for
real on hardware.

Thanks again!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
