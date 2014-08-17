Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaHQVeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 17:34:50 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:65104 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHQVet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 17:34:49 -0400
Message-ID: <53F11FF6.8030303@gmail.com>
Date: Sun, 17 Aug 2014 22:34:46 +0100
From: Iain Paton <ipaton0@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
CC: Fabio Estevam <festevam@gmail.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
References: <20140626151424.GT32514@n2100.arm.linux.org.uk> <20140627112151.GF32514@n2100.arm.linux.org.uk> <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int> <20140627163108.GP32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int> <20140806095012.GN30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int> <20140806125550.GO30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int> <20140807121248.GY30282@n2100.arm.linux.org.uk> <20140808180900.GG30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int> <CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com> <C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int>
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/14 06:42, Mattis Lorentzon wrote:

> We mostly run SSH with benchmarks using NFS, it can probably be
> triggered by using only SSH with the following loop:
> 
> # while : ; do ssh arm-card date; done

Mattis,

What sort of time does it take for you to see a problem?

I've been running the above for nearly two days on 3.16.0 on a board 
with fec interrupts routed through gpio_6 and haven't seen a hint of 
a problem.

