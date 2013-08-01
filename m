Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab3HAVbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:31:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3HAVbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:31:38 -0400
Date: Thu, 01 Aug 2013 14:31:37 -0700 (PDT)
Message-Id: <20130801.143137.331385226409040561.davem@davemloft.net>
To: olof@lixom.net
Cc: linux@arm.linux.org.uk, joe@perches.com, sammy@sammy.net,
        grundler@parisc-linux.org, mcuos.com@gmail.com,
        rajesh.borundia@qlogic.com, netdev@vger.kernel.org,
        sony.chacko@qlogic.com, linux-kernel@vger.kernel.org,
        manish.chopra@qlogic.com, pcnet32@frontier.com, ron.mercer@qlogic.com,
        gallatin@myri.com, linux-driver@qlogic.com,
        jitendra.kalsaria@qlogic.com, linux-arm-kernel@lists.infradead.org,
        shahed.shaikh@qlogic.com
Subject: Re: [PATCH V2 3/3] ethernet: Convert mac address uses of 6 to
 ETH_ALEN
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOesGMhf-2KE1B8_4CGJADCG=ceDFRrDbhTnA56kXYPWoKTScg@mail.gmail.com>
References: <20130801210618.GK23006@n2100.arm.linux.org.uk>
	<20130801.141016.1475274289112004539.davem@davemloft.net>
	<CAOesGMhf-2KE1B8_4CGJADCG=ceDFRrDbhTnA56kXYPWoKTScg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 01 Aug 2013 14:31:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Thu, 1 Aug 2013 14:24:32 -0700

> So, you might as well leave the code alone for now. It's not used on
> fast path, and the system definitely handles unaligned accesses for
> this -- it has for years already.

Fair enough, Joe please respin.
