Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3E1UB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:01:27 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:49193 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3E1UB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:01:26 -0400
Message-ID: <51A50D0F.5010909@gmail.com>
Date: Tue, 28 May 2013 22:01:19 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130528154047.GT31290@titan.lakedaemon.net> <20130528175343.77c6353d@skate> <20130528165401.GX31290@titan.lakedaemon.net>
In-Reply-To: <20130528165401.GX31290@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 06:54 PM, Jason Cooper wrote:
>> On Tue, 28 May 2013 11:40:47 -0400, Jason Cooper wrote:
>>> I'm posting the revised version as replies to patches 1, 5 and 6. Please
>>> let me know if I messed it up.  I'd like to send the PR for these
>>> shortly.
>
> $ git checkout v3.10-rc3
> $ git merge mvebu/of_pci
> $ git merge mvebu/pcie
> $ git merge mvebu/seb_clk

After manually resolving a merge conflict in arch/arm/mach-mvebu/Kconfig
I can see no obvious regression on neither Dove nor Kirkwood.

Sebastian
