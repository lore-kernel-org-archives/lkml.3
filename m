Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3LKSBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:01:11 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:53947 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3LKSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:01:09 -0500
Date: Wed, 11 Dec 2013 10:01:03 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Angus Clark <angus.clark@st.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        linus.walleij@linaro.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 01/36] mtd: st_spi_fsm: Allocate resources and
 register with MTD framework
Message-ID: <20131211180103.GQ27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-2-git-send-email-lee.jones@linaro.org>
 <20131210204635.GD27149@ld-irv-0074.broadcom.com>
 <20131211084856.GF2390@lee--X1>
 <52A83258.5070506@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A83258.5070506@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Angus,

On Wed, Dec 11, 2013 at 09:37:28AM +0000, Angus Clark wrote:
> At some stage, I would expect some of the device probing code in
> st_spi_fsm, particularly the configuration of read/write/erase operations based
> on capabilities, to be pulled into the 'spi-nor' framework.

Yes, I think this driver's device probing is starting to improve the ID
table approach that we currently have, which is why I directed a few
comments at it. I don't think it goes far enough to being useful to
others yet, though. It employs a few hacks that tie it very closely to
its own implementation, and I think this can be improved now, before its
methods are entrenched too much.

> I do not see this
> an an obstacle to st_spi_fsm being integrated earlier though; it's presence in
> the kernel would provide another example of a H/W Controller that 'spi-nor'
> needs to accommodate.

No, I don't think a generally-useful framework will pop up overnight,
but I think this driver can be one piece of the puzzle.

I await your further responses.

Thanks,
Brian
