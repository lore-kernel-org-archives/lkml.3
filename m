Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaBDUHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:07:42 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59025 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754472AbaBDUHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:07:40 -0500
Date: Tue, 4 Feb 2014 21:07:33 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Andrew Lunn <andrew@lunn.ch>,
        Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Message-ID: <20140204210733.36c2eab0@skate>
In-Reply-To: <52F10024.4030201@free-electrons.com>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<52EA2875.5020807@free-electrons.com>
	<52EA2A04.2070109@gmail.com>
	<20140203231603.GA11613@1wt.eu>
	<52F02816.1050708@gmail.com>
	<52F10024.4030201@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, 04 Feb 2014 15:58:44 +0100, Gregory CLEMENT wrote:

> > @Jason, Andrew, Gregory, Thomas:
> > Now that v3.14 is out, anything against taking this in as fixes for rc1?
> 
> I am not found of this solution I still think it should be done
> at framework level. However we still have this very annoying issue,
> and this fix is better than nothing. So I am not against taking this
> for rc1 with the hope that it will be later revert with a better
> solution.

Same opinion here. I'm fine with this solution as a temporary measure,
but it would be good to solve this problem in a nicer way. Also, making
this change doesn't impact the DT in any way, there is no problem in
having a temporary not perfect solution, and improve it later on.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
