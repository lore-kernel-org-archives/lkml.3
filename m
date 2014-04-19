Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaDSAth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:49:37 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:35169 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbaDSAte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:49:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAGVrzcZLUgpZZKAHjPSWaBs6w1XoegLaoWUAaMYUD9zW9yzq0w@mail.gmail.com>
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com>
	<1397719309-2022-4-git-send-email-computersforpeace@gmail.com>
	<CAGVrzcZLUgpZZKAHjPSWaBs6w1XoegLaoWUAaMYUD9zW9yzq0w@mail.gmail.com>
Date: Fri, 18 Apr 2014 17:49:33 -0700
Message-ID: <CAN8TOE90nh1v_84FSvF8MrN=eR-dOcXAYiOLeqRqXd3JCjfAzw@mail.gmail.com>
Subject: Re: [PATCH 3/5] mips: defconfigs: add MTD_SPI_NOR (new dependency for M25P80)
From: Brian Norris <computersforpeace@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linux-MIPS <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 5:24 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> 2014-04-17 0:21 GMT-07:00 Brian Norris <computersforpeace@gmail.com>:
>> These defconfigs contain the CONFIG_M25P80 symbol, which is now
>> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to the
>> relevant defconfigs.
>
> so CONFIG_M25P80 should select CONFIG_MTD_SPI_NOR, right? in that
> case, I do not think this is needed at all, as it would be
> automatically picked up during the build and if someone refreshes the
> defconfigs, although it cannot hurt.

Can you reply to the cover letter? 3 people have made the same
comment, and I had a rebuttal that I'm not sure if anyone considered
yet.

(And it wouldn't be picked up by 'savedefconfig', since it saves a
minimal .config; when one symbol 'select's another, the latter is not
needed in the defconfig)

Brian
