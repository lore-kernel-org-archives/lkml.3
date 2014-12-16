Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013AbaLPKQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:16:42 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:51537 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaLPKQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:16:40 -0500
Message-ID: <54900684.6040802@atmel.com>
Date: Tue, 16 Dec 2014 11:16:36 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.19 #1
References: <1418377615-15122-1-git-send-email-nicolas.ferre@atmel.com> <7hmw6oh7xh.fsf@deeprootsystems.com>
In-Reply-To: <7hmw6oh7xh.fsf@deeprootsystems.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/12/2014 23:20, Kevin Hilman a écrit :
> Nicolas Ferre <nicolas.ferre@atmel.com> writes:
> 
>> Arnd, Olof, Kevin,
>>
>> I'm sending today a "fixes" branch which somehow continues the cleanup with
>> only code removal. I was waiting for the arm-soc *and* pinctrl material to
>> reach Linus T.'s tree before sending this pull-request. In fact this sequence
>> was needed for the gpio header removal. The little patch about #include
>> deletion just follows an earlier merge conflict in arm-soc tree: I was also
>> waiting for this moment before sending the definitive fix, just to be sure.
>>
>> Otherwise, all is pretty straightforward.
>>
>> Oh, one more thing: it is based on the current Linus' git tree, I can obviously
>> rebase everything on top of 3.19-rc1 once it is released if you prefer.
> 
> Yes, waiting a bit and basing on v3.19-rc1 is preferred since none of
> this seems like urgent fixes needed for stuff introduced during the
> merge window.

Absolutely, I'll do this.

Bye,
-- 
Nicolas Ferre
