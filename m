Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaIYPS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:18:28 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51854 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaIYPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:18:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140925151403.GH19396@linutronix.de>
References: <5411C810.7070906@linutronix.de> <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com> <54129F6C.7040508@linutronix.de> <20140912094010.GE28458@ci00147.xsens-tech.local> <5412C21A.8020203@linutronix.de> <20140912102816.GF28458@ci00147.xsens-tech.local> <541716DC.9020904@linutronix.de> <20140917102812.GA20438@ci00147.xsens-tech.local> <20140921204100.GA10111@linutronix.de> <20140922092853.GH20438@ci00147.xsens-tech.local> <20140925151403.GH19396@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround for AM33xx
From: Frans Klaver <fransklaver@gmail.com>
Date: Thu, 25 Sep 2014 17:18:15 +0200
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frans Klaver <frans.klaver@xsens.com>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Message-ID: <f4e9604d-6de0-4b56-8565-3a532686e745@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2014 17:14:03 CEST, Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>* Frans Klaver | 2014-09-22 11:28:54 [+0200]:
>
>>I guess then we'd still have to answer the question why the yocto
>build
>>calls set_termios() so often, but that's not on you then. Did you
>notice
>>it even changing settings? We might want to fix this even if the
>kernel
>>should be able to cope.
>
>could you please test uart_v10_pre3? I dropped a few register sets and
>delayed the register update until TX-DMA is complete. I am traveling
>currently and have only my boneblack and it passes my limited testing.
>If it solves your problems, too then I would address Heikki's latest
>comments and prepare the final v10 (and I hope I didn't break beagle
>board in between).

That'll be Monday earliest for me. 

>
>>Thanks again,
>>Frans
>
>Sebastian
>
>_______________________________________________
>linux-arm-kernel mailing list
>linux-arm-kernel@lists.infradead.org
>http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


