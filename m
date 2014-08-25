Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaHYKSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:18:45 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60006 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752730AbaHYKSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:18:44 -0400
Date: Mon, 25 Aug 2014 11:18:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
Message-ID: <20140825101832.GT30401@n2100.arm.linux.org.uk>
References: <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int> <20140806095012.GN30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int> <20140806125550.GO30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int> <20140807121248.GY30282@n2100.arm.linux.org.uk> <20140808180900.GG30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB80435774FD@ALVA-EXMB04.alv.autoliv.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB80435774FD@ALVA-EXMB04.alv.autoliv.int>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 01:39:27PM +0000, Mattis Lorentzon wrote:
> All our tests seem to behave the same way on the Sabrelite as on our own board.
> A working theory is that the switch (3Com Switch 4400) triggers the degeneration
> of the network stack from which Linux does not seem to recover, even if we later
> bypass the switch and directly connect the board to the server machine.

Please can you try something - what happens if you completely disable
pause frame support (flow control) on all machines on the switch?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
